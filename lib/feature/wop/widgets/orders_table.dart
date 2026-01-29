import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../styles/text_styles.dart';
import '../../../../constants/color_constants.dart';
import '../models/order_model.dart';
import '../controllers/total_orders_controller.dart';

class OrdersTable extends StatefulWidget {
  final List<Order> orders;
  final TotalOrdersController controller;
  final Function(Order) onOrderTap;

  const OrdersTable({
    super.key,
    required this.orders,
    required this.controller,
    required this.onOrderTap,
  });

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 10,
            radius: const Radius.circular(5),
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 1400, // Minimum width for horizontal scroll
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kColorPrimary.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'ORDER NO',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 26,
                                  color: AppColors.kColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                'CAPACITY',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 26,
                                  color: AppColors.kColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                'PROPORTION',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 26,
                                  color: AppColors.kColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'ORDER DATE',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 26,
                                  color: AppColors.kColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'DELIVERY DATE',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 26,
                                  color: AppColors.kColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                'DAYS',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 26,
                                  color: AppColors.kColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'CYLINDER TYPE',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 26,
                                  color: AppColors.kColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'STATUS',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 26,
                                  color: AppColors.kColorSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Table Body
                    Expanded(
                      child: Scrollbar(
                        controller: _verticalScrollController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        thickness: 10,
                        radius: const Radius.circular(5),
                        child: ListView.separated(
                          controller: _verticalScrollController,
                          padding: const EdgeInsets.all(0),
                          itemCount: widget.orders.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, color: Colors.grey.shade200),
                          itemBuilder: (context, index) {
                            final order = widget.orders[index];
                            final isClickable =
                                order.status == 'Pending Planning' ||
                                order.status == 'In Production';

                            return InkWell(
                              onTap: isClickable
                                  ? () {
                                      widget.controller.selectOrder(order);
                                      widget.onOrderTap(order);
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                                color: index.isEven
                                    ? Colors.white
                                    : Colors.grey.shade50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          order.id,
                                          style: TextStyles.kBoldDongle(
                                            color: AppColors.kColorSecondary,
                                            fontSize: 23.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          order.quantity.toString(),
                                          style: TextStyles.kMediumDongle(
                                            fontSize: 23.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          order.proportion,
                                          style: TextStyles.kRegularDongle(
                                            fontSize: 23.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(order.orderDate),
                                          style: TextStyles.kRegularDongle(
                                            fontSize: 23.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(order.deliveryDate),
                                          style: TextStyles.kRegularDongle(
                                            fontSize: 23.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          order.productionDays.toString(),
                                          style: TextStyles.kBoldDongle(
                                            color: Colors.pink,
                                            fontSize: 23.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          order.cylinderType,
                                          style: TextStyles.kMediumDongle(
                                            fontSize: 23.5,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _buildStatusBadge(order),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(Order order) {
    String statusText = order.status;
    Color badgeBgColor;
    Color badgeTextColor;

    // Check for overrides based on selected status (matching Mobile logic)
    final appStatus = widget.controller.selectedStatus.value;
    String? customBadgeOverride;

    if (appStatus == 'Achievable') {
      customBadgeOverride = 'Achievable';
    } else if (appStatus == 'Not Achievable' || appStatus == 'not Achievable') {
      customBadgeOverride = 'Not Achievable';
    } else if (appStatus == 'Capacity') {
      customBadgeOverride = 'Capacity';
    }

    // 1. Custom Badge Logic (Priority)
    if (customBadgeOverride != null) {
      Color badgeColor;
      statusText = customBadgeOverride;

      if (statusText == 'Capacity') {
        badgeColor = AppColors.timelineCapacity;
      } else if (statusText == 'Achievable') {
        badgeColor = AppColors.timelineAchievable;
      } else if (statusText == 'Not Achievable') {
        badgeColor = AppColors.timelineNotAchievable;
      } else {
        badgeColor = AppColors.kColorGrey;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          statusText,
          style: TextStyles.kBoldDongle(color: badgeColor, fontSize: 20),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // 2. Standard Status Logic (OrderCard Colors)
    switch (order.status) {
      case 'In Production':
        badgeBgColor = const Color(0xFFFFF3E0); // Light Orange
        badgeTextColor = const Color(0xFFEF6C00); // Dark Orange
        break;
      case 'Delivered':
        badgeBgColor = const Color(0xFFE8F5E9); // Light Green
        badgeTextColor = const Color(0xFF2E7D32); // Dark Green
        break;
      case 'Hold/Stuck':
        badgeBgColor = const Color(0xFFFCE4EC); // Light Pink
        badgeTextColor = const Color(0xFFC2185B); // Dark Pink
        break;
      case 'Due':
      case 'Delivery Due':
        badgeBgColor = const Color(0xFFFFEBEE); // Light Red
        badgeTextColor = const Color(0xFFC62828); // Dark Red
        break;
      case 'Not Due':
        badgeBgColor = const Color(0xFFE3F2FD); // Light Blue
        badgeTextColor = const Color(0xFF1565C0); // Dark Blue
        break;
      case 'Pending Planning':
        // OrderCard didn't have explicit case, so it used default (Blue).
        // If we want to match Android exactly (Blue), use default.
        // But user might expect Orange?
        // Wait, OrderCard default is Blue. Line 46.
        // OrdersTable previous was Orange.
        // User said "shows wrong color". If they want it like Android, it should be Blue.
        badgeBgColor = const Color(0xFFE3F2FD);
        badgeTextColor = const Color(0xFF1565C0);
        break;
      default:
        badgeBgColor = const Color(0xFFE3F2FD);
        badgeTextColor = const Color(0xFF1565C0);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeTextColor.withValues(alpha: 0.1), // Subtle border
        ),
      ),
      child: Text(
        statusText,
        style: TextStyles.kBoldDongle(color: badgeTextColor, fontSize: 20),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
