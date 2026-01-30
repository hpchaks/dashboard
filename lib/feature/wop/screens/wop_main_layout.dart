import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard/feature/wop/screens/wop_dashboard_screen.dart';
import 'package:dashboard/feature/wop/screens/total_orders_screen.dart';
import 'package:dashboard/feature/wop/widgets/web_sidebar.dart';
import 'package:dashboard/feature/wop/controllers/dashboard_controller.dart';
import 'package:dashboard/feature/wop/controllers/total_orders_controller.dart'; // Added Import

import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class WOPMainLayout extends StatefulWidget {
  const WOPMainLayout({super.key});

  @override
  State<WOPMainLayout> createState() => _WOPMainLayoutState();
}

class _WOPMainLayoutState extends State<WOPMainLayout> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final DashboardController dashboardController;
  late final TotalOrdersController totalOrdersController; // Added Controller
  late final _SidebarObserver _routeObserver;

  final RxString _currentRouteName = '/'.obs; // Changed to RxString

  @override
  void initState() {
    super.initState();
    dashboardController = Get.put(DashboardController());
    totalOrdersController = Get.put(TotalOrdersController()); // Initialize

    _routeObserver = _SidebarObserver((routeName) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _currentRouteName.value = routeName ?? ''; // Update RxString safely
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!AppScreenUtils.isWeb && !AppScreenUtils.isTablet(context)) {
      return const WOPDashboardScreen();
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Sidebar on the Left
          Obx(() {
            // Dynamic Active Route Calculation
            String activeRoute = 'dashboard';
            final routeName = _currentRouteName.value;

            if (routeName == '/') {
              activeRoute = 'dashboard';
            } else if (routeName == '/pending_planning') {
              activeRoute = 'pending_planning';
            } else {
              // For all other screens (Total Orders, Details), checkDropdown Status
              final status = totalOrdersController.selectedStatus.value;
              if (status == 'Pending Planning') {
                activeRoute = 'pending_planning';
              } else {
                activeRoute = 'total_orders';
              }
            }

            return WebSidebar(
              activeRoute: activeRoute,
              totalOrdersCount: dashboardController.metrics['totalOrders'] ?? 0,
              pendingCount: dashboardController.metrics['pending'] ?? 0,
              onDashboardTap: () {
                if (activeRoute != 'dashboard') {
                  _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    '/',
                    (_) => false,
                  );
                }
              },
              onTotalOrdersTap: () {
                if (activeRoute != 'total_orders') {
                  if (activeRoute == 'dashboard') {
                    _navigatorKey.currentState?.pushNamed('/total_orders');
                  } else {
                    _navigatorKey.currentState?.pushReplacementNamed(
                      '/total_orders',
                    );
                  }
                  // Reset status to 'Total Order' if explicity clicked?
                  // User didn't ask, but usually clicking sidebar resets filter.
                  // totalOrdersController.selectedStatus.value = 'Total Order';
                }
              },
              onPendingPlanningTap: () {
                if (activeRoute != 'pending_planning') {
                  if (activeRoute == 'dashboard') {
                    _navigatorKey.currentState?.pushNamed('/pending_planning');
                  } else {
                    _navigatorKey.currentState?.pushReplacementNamed(
                      '/pending_planning',
                    );
                  }
                  // Set status to Pending?
                  // totalOrdersController.selectedStatus.value = 'Pending Planning';
                }
              },
            );
          }),

          // Main Content Area changing on the Right
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              observers: [_routeObserver],
              onGenerateRoute: (settings) {
                Widget page;

                if (settings.name == '/total_orders') {
                  page = const TotalOrdersScreen(initialStatus: 'Total Order');
                } else if (settings.name == '/pending_planning') {
                  page = const TotalOrdersScreen(
                    initialStatus: 'Pending Planning',
                  );
                } else {
                  page = const WOPDashboardScreen();
                }

                return MaterialPageRoute(
                  builder: (context) => page,
                  settings: settings,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarObserver extends NavigatorObserver {
  final ValueChanged<String?> onRouteChanged;

  _SidebarObserver(this.onRouteChanged);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    onRouteChanged(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      onRouteChanged(previousRoute.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      onRouteChanged(newRoute.settings.name);
    }
  }
}
