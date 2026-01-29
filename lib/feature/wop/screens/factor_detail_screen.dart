import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard/feature/wop/controllers/dashboard_controller.dart';
import 'package:dashboard/feature/wop/models/order_model.dart';
import 'package:dashboard/feature/wop/controllers/total_orders_controller.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:dashboard/feature/wop/controllers/factor_detail_controller.dart';
import 'package:dashboard/feature/wop/widgets/card.dart'; // Import OrderCard
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart'; // Import AppScreenUtils

class StatusConfig {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;

  StatusConfig({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
  });
}

class FactorDetailScreen extends StatelessWidget {
  final Order order;
  final int factorIndex;
  final String title;
  final bool isReadOnly;
  final bool showAppBar;
  final VoidCallback? onBack;

  const FactorDetailScreen({
    required this.order,
    required this.factorIndex,
    required this.title,
    this.isReadOnly = false,
    this.showAppBar = true,
    this.onBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalOrdersController = Get.find<TotalOrdersController>();
    final controller = Get.put(
      FactorDetailController(
        totalOrdersController: totalOrdersController,
        onProcessed: onBack,
      ),
      tag: order.id,
    );

    final isWeb = AppScreenUtils.isWeb || AppScreenUtils.isTablet(context);

    if (!showAppBar) {
      return isWeb
          ? _buildWebLayout(context, controller)
          : _buildMobileLayout(context, controller);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: isWeb
          ? _buildWebLayout(context, controller)
          : _buildMobileLayout(context, controller),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.kColorSecondary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Factor $factorIndex: $title',
        style: TextStyles.kBoldDongle(
          color: AppColors.kColorSecondary,
          fontSize: (AppScreenUtils.isWeb || AppScreenUtils.isTablet(context))
              ? 36
              : FontSizes.k18FontSize,
        ),
      ),
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    FactorDetailController controller,
  ) {
    if (!showAppBar) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContent(context, controller),
            const SizedBox(height: 32),
            _buildActionButtons(context, controller),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Panel - Order Card
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: OrderCard(order: order),
          ),
        ),
        // Right Panel - Planning Content
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(left: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Factor $factorIndex: $title',
                    style: TextStyles.kBoldDongle(
                      fontSize: 28,
                      color: AppColors.kColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildContent(context, controller),
                  const SizedBox(height: 48),
                  _buildActionButtons(context, controller),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    FactorDetailController controller,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContent(context, controller),
          const SizedBox(height: 48),
          _buildActionButtons(context, controller),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    FactorDetailController controller,
  ) {
    return Obx(() {
      final noIssueSelected = controller.isNoIssueSelected.value;
      final isFactor4Selection = factorIndex == 4 && noIssueSelected;
      final showDone = factorIndex == 1 || isFactor4Selection;

      if (!showDone || isReadOnly) return const SizedBox.shrink();

      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (factorIndex == 1) {
              controller.totalOrdersController.isFactor1Complete.value = true;
            } else if (factorIndex == 4) {
              controller.markFactor4Complete(true);
            }
            controller.popOrFinish(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kColorSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'DONE',
            style: TextStyles.kBoldDongle(
              color: Colors.white,
              fontSize: FontSizes.k16FontSize,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContent(
    BuildContext context,
    FactorDetailController controller,
  ) {
    switch (factorIndex) {
      case 1:
        return _buildCapacityFactor(context, controller);
      case 2:
        return _buildCylinderFactor(context, controller);
      case 3:
        return _buildMaterialFactor(context, controller);
      case 4:
        return _buildIssueFactor(context, controller);
      case 5:
        return _buildDeliveryFactor(context, controller);
      default:
        return const SizedBox();
    }
  }

  Widget _buildCapacityFactor(
    BuildContext context,
    FactorDetailController controller,
  ) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Production Capacity',
          style: TextStyles.kBoldDongle(
            fontSize: FontSizes.k16FontSize,
            color: AppColors.kColorPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: Obx(() {
            final weekDates = dashboardController.weekDates;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = weekDates[index];
                final dayNum = date.day;
                final dayName = DateFormat('EEE').format(date);
                final today = DateTime(2026, 1, 22);
                final isToday =
                    date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
                return Obx(() {
                  final isSelected =
                      controller.selectedDate.value.year == date.year &&
                      controller.selectedDate.value.month == date.month &&
                      controller.selectedDate.value.day == date.day;

                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => controller.updateCapacityForDate(dayNum),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.15)
                                : (isToday
                                      ? Colors.blue.withOpacity(0.04)
                                      : Colors.grey.shade50),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : (isToday
                                        ? Colors.blue.withOpacity(0.2)
                                        : Colors.grey.shade200),
                              width: isSelected ? 2.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayName,
                                style: TextStyles.kMediumDongle(
                                  fontSize: 10,
                                  color: AppColors.kColorGrey,
                                ),
                              ),
                              Text(
                                '$dayNum',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.blue.shade700
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (controller.getUsageForDate(date) > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    'Cap: ${controller.getUsageForDate(date)}',
                                    style: TextStyles.kBoldDongle(
                                      fontSize: 10,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  'No Plan',
                                  style: TextStyles.kRegularDongle(
                                    fontSize: 10,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            );
          }),
        ),
        const SizedBox(height: 32),
        Obx(
          () => Column(
            children: [
              _buildCapacityIndicator(
                label: controller.capacityLabel.value,
                current: controller.currentDailyUsage.value,
                total: controller.totalDailyCapacity.value,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildCapacityIndicator(
                      label: 'Proportion Capacity (${order.gasType})',
                      current: controller.proportionCurrentUsage.value,
                      total: controller.proportionMaxCapacity.value,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: AppColors.kColorSecondary,
                        size: 24,
                      ),
                      onPressed: () => _showCapacityInfo(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCylinderFactor(
    BuildContext context,
    FactorDetailController controller,
  ) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Cylinder Type', order.cylinderType),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Current Status',
            controller.cylinderStatus.value,
            color:
                controller.isQAApproved.value ||
                    controller.isStockAvailable.value
                ? Colors.green
                : (controller.isQAFailed.value ||
                          (controller.isStockChecked.value &&
                              !controller.isStockAvailable.value)
                      ? Colors.red
                      : Colors.orange),
          ),
          const SizedBox(height: 32),
          if (order.cylinderType.contains('OP') &&
              !controller.isSentForQA.value)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Mandatory Inspection Checklist',
                  style: TextStyles.kBoldDongle(
                    fontSize: FontSizes.k15FontSize,
                    color: AppColors.kColorPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Verify all parameters before sending for QA',
                  style: TextStyles.kRegularDongle(
                    fontSize: 12,
                    color: AppColors.kColorGrey,
                  ),
                ),
                const SizedBox(height: 16),
                ...controller.qaChecklist.keys.map((key) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => controller.toggleCheck(key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: (controller.qaChecklist[key] ?? false)
                              ? Colors.green.withOpacity(0.05)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: (controller.qaChecklist[key] ?? false)
                                ? Colors.green.withOpacity(0.3)
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: (controller.qaChecklist[key] ?? false)
                                    ? Colors.green
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: (controller.qaChecklist[key] ?? false)
                                      ? Colors.green
                                      : Colors.grey.shade400,
                                ),
                              ),
                              child: (controller.qaChecklist[key] ?? false)
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check $key',
                                    style: TextStyles.kBoldDongle(
                                      fontSize: FontSizes.k14FontSize,
                                      color:
                                          (controller.qaChecklist[key] ?? false)
                                          ? Colors.green.shade700
                                          : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    controller.checklistLabels[key] ?? '',
                                    style: TextStyles.kRegularDongle(
                                      fontSize: FontSizes.k12FontSize,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isAtLeastOneChecked
                        ? () => controller.sendForQA(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kColorSecondary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'APPROVE INSPECTION',
                      style: TextStyles.kBoldDongle(
                        color: Colors.white,
                        fontSize: FontSizes.k15FontSize,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => controller.rejectForQA(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'REJECT QA',
                      style: TextStyles.kBoldDongle(
                        color: Colors.red,
                        fontSize: FontSizes.k14FontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          if (controller.isSentForQA.value &&
              !controller.isQAApproved.value &&
              !controller.isQAFailed.value)
            Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Waiting for QA feedback. Use buttons below to simulate response.',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (!isReadOnly) ...[
                  _buildActionButton(
                    'SIMULATE: QA APPROVED',
                    Colors.green,
                    () => controller.approveQA(context),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton('SIMULATE: QA REJECTED', Colors.red, () {
                    // Show Rejection Dialog
                    final reasonController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reject QA'),
                        content: TextField(
                          controller: reasonController,
                          decoration: const InputDecoration(
                            labelText: 'Rejection Reason',
                            hintText: 'Enter details...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (reasonController.text.isNotEmpty) {
                                Navigator.pop(context); // Close dialog
                                controller.failQA(
                                  reasonController.text,
                                  context,
                                ); // Process rejection
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Reject',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),

          if (!order.cylinderType.contains('OP') &&
              !order.cylinderType.toLowerCase().contains('vadilal') &&
              !controller.isStockChecked.value)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Heading
                Text(
                  'Cylinder Allocation',
                  style: TextStyles.kBoldDongle(
                    fontSize: FontSizes.k16FontSize,
                    color: AppColors.kColorPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the number of cylinders you want to allocate for this order.',
                  style: TextStyles.kRegularDongle(
                    fontSize: 12,
                    color: AppColors.kColorGrey,
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Row
                Row(
                  children: [
                    _buildAllocationStat(
                      'Required',
                      '${order.quantity}',
                      AppColors.kColorPrimary,
                    ),
                    const SizedBox(width: 12),
                    _buildAllocationStat(
                      'In Stock',
                      '${controller.availableStockCount.value}',
                      Colors.green,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const SizedBox(height: 24),
                // Automated Logic Message
                Obx(() {
                  final stockVal = controller.availableStockCount.value;
                  final reqVal = order.quantity;
                  final isPartial = stockVal < reqVal;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: isPartial
                          ? Colors.orange.withOpacity(0.05)
                          : Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPartial
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline,
                          size: 18,
                          color: isPartial ? Colors.orange : Colors.green,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isPartial
                                ? 'Stock is short. System will allocate $stockVal units and move ${reqVal - stockVal} to waiting list.'
                                : 'Full stock available. System will reserve all ${reqVal} cylinders.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isPartial
                                  ? Colors.orange.shade800
                                  : Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 32),

                Obx(() {
                  if (isReadOnly) return const SizedBox();

                  final stockVal = controller.availableStockCount.value;
                  final reqVal = order.quantity;
                  final isPartial = stockVal < reqVal;

                  if (isPartial) {
                    return _buildActionButton(
                      'MOVE TO WAITING FOR CYLINDERS',
                      Colors.orange,
                      () => controller.moveOrderToWaitingForCylinders(context),
                    );
                  }

                  return _buildActionButton(
                    'CONFIRM ALLOCATION',
                    AppColors.kColorSecondary,
                    () => controller.allocateCylinders(reqVal, context),
                  );
                }),
              ],
            ),

          if (order.cylinderType.toLowerCase().contains('vadilal'))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Vadilal Cylinder Availability',
                  style: TextStyles.kBoldDongle(
                    fontSize: FontSizes.k16FontSize,
                    color: AppColors.kColorPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Stock Stats Row
                Row(
                  children: [
                    _buildAllocationStat(
                      'Required',
                      '${order.quantity}',
                      AppColors.kColorPrimary,
                    ),
                    const SizedBox(width: 12),
                    Obx(
                      () => _buildAllocationStat(
                        'In Stock',
                        '${controller.availableStockCount.value}',
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: controller.isVadilalCylinderAvailable.value
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: controller.isVadilalCylinderAvailable.value
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        controller.isVadilalCylinderAvailable.value
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: controller.isVadilalCylinderAvailable.value
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        controller.isVadilalCylinderAvailable.value
                            ? 'Cylinders Available in Stock'
                            : 'No Cylinders Available',
                        style: TextStyles.kBoldDongle(
                          color: controller.isVadilalCylinderAvailable.value
                              ? Colors.green
                              : Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (controller.isVadilalCylinderAvailable.value)
                  _buildActionButton('CONFIRM & PROCEED', Colors.green, () {
                    controller.totalOrdersController.isFactor2Complete.value =
                        true;
                    Navigator.pop(context);
                  })
                else
                  _buildActionButton(
                    'MOVE TO WAITING FOR CYLINDERS',
                    Colors.orange,
                    () => controller.moveOrderToWaitingForCylinders(context),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMaterialFactor(
    BuildContext context,
    FactorDetailController controller,
  ) {
    return Obx(() {
      final isAllAvailable = controller.checkDirectAvailability;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Material Requirements',
            style: TextStyles.kBoldDongle(
              fontSize: FontSizes.k16FontSize,
              color: AppColors.kColorPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Direct Material List
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: controller.rawMaterialItems.map((item) {
                final isShort = item['status'] == 'Shortage';
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      leading: Icon(
                        isShort
                            ? Icons.error_outline
                            : Icons.check_circle_outline,
                        color: isShort ? Colors.orange : Colors.green,
                        size: 20,
                      ),
                      title: Text(
                        item['name'],
                        style: TextStyles.kBoldDongle(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Required: ${item['req']} | Stock: ${item['stock']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isShort ? Colors.orange : Colors.green)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item['status'],
                          style: TextStyle(
                            fontSize: FontSizes.k11FontSize,
                            fontWeight: FontWeight.bold,
                            color: isShort
                                ? Colors.orange.shade800
                                : Colors.green.shade800,
                          ),
                        ),
                      ),
                    ),
                    if (item != controller.rawMaterialItems.last)
                      Divider(height: 1, color: Colors.grey.shade200),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),

          if (isAllAvailable && !isReadOnly)
            _buildActionButton(
              'DONE',
              AppColors.kColorSecondary,
              () => controller.selectMaterialOption(true, context),
            )
          else if (!isReadOnly && !controller.indentGenerated.value)
            _buildActionButton(
              'GENERATE INDENT',
              Colors.orange,
              () => controller.selectMaterialOption(false, context),
            ),

          if (controller.isMaterialWaiting.value) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.hourglass_empty,
                    color: Colors.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This order is in Pending Planning (Waiting for Stock).',
                      style: TextStyles.kMediumDongle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              'SIMULATE: RECEIVE STOCK',
              Colors.green.shade600,
              () => controller.receiveMaterialStock(context),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildIssueFactor(
    BuildContext context,
    FactorDetailController controller,
  ) {
    return Obx(() {
      final hasIssue = controller.hasProductionIssue.value;
      final isComplete = controller.isFactor4Complete.value;

      if (isComplete || hasIssue) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.expectedIssueDate.value != null) ...[
              _buildDetailRow(
                'Expected Availability Date',
                DateFormat(
                  'dd MMM yyyy',
                ).format(controller.expectedIssueDate.value!),
                color: Colors.orange.shade800,
              ),
              const SizedBox(height: 16),
            ],
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hasIssue
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasIssue ? Colors.orange : Colors.green,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    hasIssue ? Icons.warning_amber_rounded : Icons.check_circle,
                    color: hasIssue ? Colors.orange : Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasIssue
                              ? 'Production Issue Logged'
                              : 'No Production Issues',
                          style: TextStyles.kBoldDongle(
                            fontSize: FontSizes.k16FontSize,
                            color: Colors.black87,
                          ),
                        ),
                        if (hasIssue)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              controller.productionRemark.value,
                              style: TextStyles.kMediumDongle(
                                fontSize: FontSizes.k14FontSize,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButton(
              'EDIT / UNDO',
              AppColors.kColorGrey,
              () => controller.markFactor4Complete(false),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check for any production constraints:',
            style: TextStyles.kMediumDongle(
              fontSize: FontSizes.k14FontSize,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Obx(() {
                    final selected = controller.isNoIssueSelected.value;
                    return ElevatedButton(
                      onPressed: () {
                        controller.isNoIssueSelected.value = true;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected
                            ? Colors.green.shade100
                            : Colors.green.shade50,
                        foregroundColor: Colors.green.shade700,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: selected
                                ? Colors.green.shade600
                                : Colors.green.shade200,
                            width: selected ? 2 : 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selected
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'NO ISSUES',
                            style: TextStyles.kBoldDongle(fontSize: 16),
                          ),
                          Text(
                            'Proceed to Delivery',
                            style: TextStyles.kRegularDongle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      // Toggle a local state or use a dialog?
                      // Let's use a bottom sheet or dialog to enter remark
                      _showIssueDialog(context, controller);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade50,
                      foregroundColor: Colors.orange.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.orange.shade200),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.report_problem_outlined, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'LOG ISSUE',
                          style: TextStyles.kBoldDongle(fontSize: 16),
                        ),
                        Text(
                          'Add Remark',
                          style: TextStyles.kRegularDongle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDeliveryFactor(
    BuildContext context,
    FactorDetailController controller,
  ) {
    return Obx(() {
      final orderDateStr = DateFormat('dd MMM yyyy').format(order.deliveryDate);
      final simDateStr = DateFormat(
        'EEE, dd MMM yyyy',
      ).format(controller.simulationDeliveryDate.value);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Promised Date', orderDateStr),
          const SizedBox(height: 16),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.simulationDeliveryDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2027),
                );
                if (picked != null) {
                  controller.updateDeliveryDate(picked);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue.withOpacity(0.1)),
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Simulated Delivery Date',
                            style: TextStyles.kMediumDongle(
                              fontSize: 11,
                              color: Colors.blue.shade800.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            simDateStr,
                            style: TextStyles.kBoldDongle(
                              fontSize: 18,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.hasFactor5Issue.value)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.report_problem, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Logistics Issue Logged',
                        style: TextStyles.kBoldDongle(
                          fontSize: 14,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.factor5Remark.value,
                    style: TextStyles.kRegularDongle(
                      fontSize: 13,
                      color: Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),
          if (!controller.totalOrdersController.isFactor5Complete.value)
            _buildActionButton('CONFIRM DELIVERY', Colors.green, () {
              controller.markDelivered(context);
            })
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Delivered Successfully',
                    style: TextStyles.kBoldDongle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.totalOrdersController.isFactor5Complete.value =
                          false;
                    },
                    child: const Text('Undo'),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogisticsDialog(context, controller),
              icon: const Icon(Icons.report_problem, size: 18),
              label: const Text('LOG LOGISTICS ISSUE'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAllocationStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyles.kBoldDongle(fontSize: 18, color: color),
            ),
            Text(
              label,
              style: TextStyles.kMediumDongle(
                fontSize: 10,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.kMediumDongle(
            fontSize: FontSizes.k12FontSize,
            color: AppColors.kColorGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyles.kBoldDongle(
            fontSize: FontSizes.k16FontSize,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyles.kBoldDongle(
            fontSize: FontSizes.k15FontSize,
            color: onPressed == null ? Colors.grey.shade500 : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCapacityIndicator({
    required String label,
    required int current,
    required int total,
    required Color color,
  }) {
    double progress = current / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyles.kMediumDongle(fontSize: FontSizes.k14FontSize),
            ),
            Text(
              '$current / $total',
              style: TextStyles.kBoldDongle(
                fontSize: FontSizes.k14FontSize,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  void _showCapacityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Production Capacity Rules',
          style: TextStyles.kBoldDongle(
            color: AppColors.kColorPrimary,
            fontSize: FontSizes.k18FontSize,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBullet('Total Daily Capacity = 10'),
            _buildInfoBullet('X proportion = max 3/day'),
            _buildInfoBullet('Y proportion = max 5/day'),
            _buildInfoBullet('Z proportion = max 7/day'),
            const SizedBox(height: 12),
            Text(
              'System ensures total does not exceed 10 and individual limits are respected.',
              style: TextStyles.kMediumDongle(
                fontSize: FontSizes.k12FontSize,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'GOT IT',
              style: TextStyles.kBoldDongle(color: AppColors.kColorSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: AppColors.kColorSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyles.kSemiBoldDongle(
                fontSize: FontSizes.k14FontSize,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showIssueDialog(
    BuildContext context,
    FactorDetailController controller,
  ) {
    final remarkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Log Production Issue',
              style: TextStyles.kBoldDongle(
                color: AppColors.kColorPrimary,
                fontSize: FontSizes.k18FontSize,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Describe the issue causing delay:',
                  style: TextStyles.kMediumDongle(
                    fontSize: 12,
                    color: AppColors.kColorGrey,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: remarkController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Breakdown, Power Failure...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (remarkController.text.isNotEmpty) {
                    controller.markFactor4Complete(
                      false,
                      remark: remarkController.text,
                    );
                    Navigator.pop(context); // Close dialog
                    // Optional: Close screen? The user said "move to Due", so maybe closing current detail is best.
                    controller.popOrFinish(context);
                  } else {
                    Get.snackbar(
                      'Required',
                      'Please enter an issue remark.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'SUBMIT ISSUE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLogisticsDialog(
    BuildContext context,
    FactorDetailController controller,
  ) {
    final remarkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Log Logistics Issue',
              style: TextStyles.kBoldDongle(
                color: AppColors.kColorPrimary,
                fontSize: FontSizes.k18FontSize,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Describe the logistics issue:',
                  style: TextStyles.kMediumDongle(
                    fontSize: 12,
                    color: AppColors.kColorGrey,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: remarkController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Vehicle Breakdown, Driver Unavailable...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (remarkController.text.isNotEmpty) {
                    controller.logLogisticsIssue(remarkController.text);
                    Navigator.pop(context); // Close dialog
                  } else {
                    Get.snackbar(
                      'Required',
                      'Please enter an issue remark.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'LOG ISSUE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
