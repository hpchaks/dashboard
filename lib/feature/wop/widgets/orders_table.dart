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
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'ORDER NO',
                              style: TextStyles.kBoldDongle(
                                fontSize: 26,
                                color: AppColors.kColorSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'CAPACITY',
                              style: TextStyles.kBoldDongle(
                                fontSize: 26,
                                color: AppColors.kColorSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'PROPORTION',
                              style: TextStyles.kBoldDongle(
                                fontSize: 26,
                                color: AppColors.kColorSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'ORDER DATE',
                              style: TextStyles.kBoldDongle(
                                fontSize: 26,
                                color: AppColors.kColorSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'DELIVERY DATE',
                              style: TextStyles.kBoldDongle(
                                fontSize: 26,
                                color: AppColors.kColorSecondary,
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
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'CYLINDER TYPE',
                              style: TextStyles.kBoldDongle(
                                fontSize: 26,
                                color: AppColors.kColorSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'STATUS',
                              style: TextStyles.kBoldDongle(
                                fontSize: 26,
                                color: AppColors.kColorSecondary,
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
                                    : Colors.grey.shade50.withValues(
                                        alpha: 0.5,
                                      ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        order.id,
                                        style: TextStyles.kBoldDongle(
                                          color: AppColors.kColorSecondary,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        order.quantity.toString(),
                                        style: TextStyles.kMediumDongle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        order.proportion,
                                        style: TextStyles.kRegularDongle(
                                          fontSize: 26,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(order.orderDate),
                                        style: TextStyles.kRegularDongle(
                                          fontSize: 26,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(order.deliveryDate),
                                        style: TextStyles.kRegularDongle(
                                          fontSize: 26,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.pink.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            order.productionDays.toString(),
                                            style: TextStyles.kBoldDongle(
                                              color: Colors.pink,
                                              fontSize: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          order.cylinderType,
                                          style: TextStyles.kMediumDongle(
                                            fontSize: 26,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _buildStatusBadge(order.status),
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

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    Color bgColor;

    switch (status) {
      case 'Pending Planning':
        badgeColor = Colors.orange;
        bgColor = Colors.orange.shade50;
        break;
      case 'In Production':
        badgeColor = Colors.blue;
        bgColor = Colors.blue.shade50;
        break;
      case 'Delivered':
        badgeColor = Colors.green;
        bgColor = Colors.green.shade50;
        break;
      case 'Due':
        badgeColor = Colors.red;
        bgColor = Colors.red.shade50;
        break;
      default:
        badgeColor = Colors.grey;
        bgColor = Colors.grey.shade100;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyles.kMediumDongle(color: badgeColor, fontSize: 20),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
