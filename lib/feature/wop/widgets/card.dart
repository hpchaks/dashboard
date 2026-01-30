import 'package:flutter/material.dart';
import 'package:dashboard/feature/wop/models/order_model.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/styles/font_sizes.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  final String? customBadge;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.customBadge,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status badge colors
    Color badgeBgColor;
    Color badgeTextColor;
    String statusText = order.status;

    // Default badge mapping
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
      default:
        badgeBgColor = const Color(0xFFE3F2FD);
        badgeTextColor = const Color(0xFF1565C0);
    }

    // Use widget prop OR model prop
    // final effectiveBadge = customBadge ?? order.customBadge;
    // REVERTED: We want explicit control. Only use customBadge passed as param.

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.kColorPrimary, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Order No + Status/Custom Badge
                Row(
                  children: [
                    Expanded(child: _buildLabelValue('Order no : ', order.id)),
                    const SizedBox(width: 8),
                    // Only show status badge based on order.status primarily
                    // Unless a specific `customBadge` override is passed to the Card widget constructor
                    if (customBadge != null)
                      Builder(
                        builder: (context) {
                          final badgeText = customBadge!;
                          Color? badgeColor;

                          if (badgeText == 'Capacity') {
                            badgeColor = AppColors.timelineCapacity;
                          } else if (badgeText == 'Achievable') {
                            badgeColor = AppColors.timelineAchievable;
                          } else if (badgeText == 'Not Achievable' ||
                              badgeText == 'not Achievable') {
                            badgeColor = AppColors.timelineNotAchievable;
                          } else if (badgeText == 'Due' ||
                              badgeText == 'Delivery Due') {
                            badgeColor = AppColors.timelineDue;
                          } else if (badgeText == 'In Production') {
                            badgeColor = AppColors.timelineInProduction;
                          } else if (badgeText == 'Delivered') {
                            badgeColor = AppColors.timelineDelivered;
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: (badgeColor ?? AppColors.kColorGrey)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyles.kBoldDongle(
                                fontSize: FontSizes.k11FontSize,
                                color: badgeColor ?? AppColors.kColorGrey,
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyles.kBoldDongle(
                            fontSize: FontSizes.k11FontSize,
                            color: badgeTextColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),

                // Row 2: Capacity Value
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: double.infinity,
                      child: _buildLabelValue(
                        'Capacity : ',
                        '${order.quantity}',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 2),

                // Row 3: Proportion
                SizedBox(
                  width: double.infinity,
                  child: _buildLabelValue('Proportion : ', order.proportion),
                ),
                const SizedBox(height: 2),

                // Row 4: Dates & Days
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelValue(
                            'Order Date : ',
                            DateFormat('dd/MM/yyyy').format(order.orderDate),
                          ),
                          const SizedBox(height: 2),
                          _buildLabelValue(
                            'Delivery Date : ',
                            DateFormat('dd/MM/yyyy').format(order.deliveryDate),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildLabelValue('Prod Days : ', '${order.productionDays}'),
                  ],
                ),
                const SizedBox(height: 2),

                // Row 5: Cylinder Type
                _buildLabelValue('Cylinder Type : ', order.cylinderType),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyles.kBoldDongle(
              color: AppColors.kColorSecondary,
              fontSize: FontSizes.k14FontSize,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyles.kBoldDongle(
              color: AppColors.kColorPrimary,
              fontSize: FontSizes.k14FontSize,
            ),
          ),
        ],
      ),
    );
  }
}
