import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard/feature/wop/screens/wop_dashboard_screen.dart';
import 'package:dashboard/feature/wop/screens/total_orders_screen.dart';
import 'package:dashboard/feature/wop/widgets/web_sidebar.dart';
import 'package:dashboard/feature/wop/controllers/dashboard_controller.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class WOPMainLayout extends StatefulWidget {
  const WOPMainLayout({Key? key}) : super(key: key);

  @override
  State<WOPMainLayout> createState() => _WOPMainLayoutState();
}

class _WOPMainLayoutState extends State<WOPMainLayout> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  // We use Get.find or Get.put to ensuring controller exists,
  // though it might be initialized inside WOPDashboardScreen.
  // We'll put it here to be safe and access metrics.
  late final DashboardController dashboardController;

  String _activeRoute = 'dashboard';

  @override
  void initState() {
    super.initState();
    dashboardController = Get.put(DashboardController());
  }

  @override
  Widget build(BuildContext context) {
    // If mobile, we might not want the sidebar layout?
    // The user specifically asked for "web layout" behavior with fixed sidebar.
    // Assuming this is for Web/Desktop.
    if (!AppScreenUtils.isWeb && !AppScreenUtils.isTablet(context)) {
      return const WOPDashboardScreen();
      // Or handle mobile navigation differently. For now, WOPDashboardScreen has mobile layout.
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Sidebar on the Left
          Obx(
            () => WebSidebar(
              activeRoute: _activeRoute,
              totalOrdersCount: dashboardController.metrics['totalOrders'] ?? 0,
              pendingCount: dashboardController.metrics['pending'] ?? 0,
              onDashboardTap: () {
                if (_activeRoute != 'dashboard') {
                  _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    '/',
                    (_) => false,
                  );
                  if (mounted) setState(() => _activeRoute = 'dashboard');
                }
              },
              onTotalOrdersTap: () {
                if (_activeRoute != 'total_orders') {
                  // If we are already on a non-dashboard route, replace it.
                  // If we are on dashboard (root), push it.
                  if (_activeRoute == 'dashboard') {
                    _navigatorKey.currentState?.pushNamed('/total_orders');
                  } else {
                    _navigatorKey.currentState?.pushReplacementNamed(
                      '/total_orders',
                    );
                  }
                  if (mounted) setState(() => _activeRoute = 'total_orders');
                }
              },
              onPendingPlanningTap: () {
                if (_activeRoute != 'pending_planning') {
                  if (_activeRoute == 'dashboard') {
                    _navigatorKey.currentState?.pushNamed('/pending_planning');
                  } else {
                    _navigatorKey.currentState?.pushReplacementNamed(
                      '/pending_planning',
                    );
                  }
                  if (mounted)
                    setState(() => _activeRoute = 'pending_planning');
                }
              },
            ),
          ),

          // Main Content Area changing on the Right
          Expanded(
            child: Navigator(
              key: _navigatorKey,
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
