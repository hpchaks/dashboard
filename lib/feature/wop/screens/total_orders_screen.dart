import 'package:flutter/material.dart';
import 'package:dashboard/feature/wop/controllers/total_orders_controller.dart';
import 'package:dashboard/feature/wop/screens/factor_detail_screen.dart' as fds;
import 'package:dashboard/feature/wop/screens/wop_dashboard_screen.dart';
import 'package:dashboard/feature/wop/widgets/card.dart';
import 'package:dashboard/feature/wop/models/order_model.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:get/get.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';
import 'package:intl/intl.dart';

import '../widgets/orders_table.dart';

class TotalOrdersScreen extends StatefulWidget {
  final String? initialStatus;
  final DateTime? initialDate;
  final DateTime? initialDateFrom;
  final DateTime? initialDateTo;
  final List<Order>? preloadedOrders;

  const TotalOrdersScreen({
    this.initialStatus,
    this.initialDate,
    this.initialDateFrom,
    this.initialDateTo,
    this.preloadedOrders,
    super.key,
  });

  @override
  State<TotalOrdersScreen> createState() => _TotalOrdersScreenState();
}

class _TotalOrdersScreenState extends State<TotalOrdersScreen> {
  late final TotalOrdersController controller;

  @override
  void initState() {
    super.initState();
    // Use Get.put to ensure it exists, but we need to reset it for the new screen context if it's being reused.
    // However, since we are using pushReplacement, the old one might be disposed?
    // If not disposed, we get the same instance.
    if (Get.isRegistered<TotalOrdersController>()) {
      controller = Get.find<TotalOrdersController>();
    } else {
      controller = Get.put(TotalOrdersController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.preloadedOrders != null &&
          widget.preloadedOrders!.isNotEmpty) {
        controller.setPreloadedOrders(widget.preloadedOrders!);
      } else {
        controller.clearPreloadedOrders();
      }

      if (widget.initialStatus != null) {
        controller.selectedStatus.value = widget.initialStatus!;
      } else {
        controller.selectedStatus.value = 'Total Order';
      }

      if (widget.initialDateFrom != null && widget.initialDateTo != null) {
        controller.setDateRange(widget.initialDateFrom, widget.initialDateTo);
      } else if (widget.initialDate != null) {
        controller.selectDate(widget.initialDate!);
      } else {
        controller.clearDate();
      }

      controller.selectedCylinder.value = 'All Cylinders';
      controller.selectedSort.value = 'Sort';
      controller.searchQuery.value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = AppScreenUtils.isWeb || AppScreenUtils.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: isWeb ? _buildWebLayout() : _buildMobileLayout()),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Content
        Expanded(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      String titleText = controller.selectedStatus.value;
                      if (controller.selectedDate.value != null) {
                        titleText = DateFormat(
                          'dd MMM yyyy',
                        ).format(controller.selectedDate.value!);
                      }
                      return Text(
                        titleText,
                        style: TextStyles.kBoldDongle(
                          fontSize: 36,
                          color: AppColors.kColorSecondary,
                        ),
                      );
                    }),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.kColorSecondary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              // Filters Bar
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(flex: 3, child: _buildSearchBar()),
                      const SizedBox(width: 16),
                      // Date Filter
                      SizedBox(width: 60, child: _buildDateFilterButton()),
                      const SizedBox(width: 16),
                      // Status Dropdown
                      Expanded(flex: 2, child: _buildStatusDropdown()),
                      const SizedBox(width: 16),
                      // Cylinder Dropdown
                      Expanded(flex: 2, child: _buildCylinderDropdown()),
                      const SizedBox(width: 16),
                      // Sort Dropdown
                      Expanded(flex: 2, child: _buildSortDropdown()),
                    ],
                  ),
                ),
              ),
              // Active Filters Indicator
              Obx(() {
                if (controller.selectedDate.value != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_alt,
                              size: 16,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Date: ${DateFormat('dd MMM yyyy').format(controller.selectedDate.value!)}',
                              style: TextStyles.kMediumDongle(
                                fontSize: 16,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const VerticalDivider(width: 1, thickness: 1),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: () => controller.clearDate(),
                              child: Text(
                                'Clear',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 16,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              // Orders Content
              Expanded(
                child: Obx(() {
                  final orders = controller.filteredOrders;

                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders found',
                            style: TextStyles.kBoldDongle(
                              fontSize: 20,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return OrdersTable(
                    orders: orders,
                    controller: controller,
                    onOrderTap: (order) {
                      Get.to(() => const OrderDetailScreen());
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        WOPAppBar(
          title: 'Total Orders',
          showSearchBar: false,
          selectedDate: controller.selectedDate,
          selectedStatus: controller.selectedStatus,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildSearchBar()),
                  const SizedBox(width: 8),
                  _buildDateFilterButton(),
                ],
              ),
              const SizedBox(height: 12),
              _buildStatusDropdown(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildCylinderDropdown()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSortDropdown()),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final orders = controller.filteredOrders;

            if (orders.isEmpty) {
              return Center(
                child: Text(
                  'No orders found',
                  style: TextStyles.kMediumDongle(
                    fontSize: FontSizes.k24FontSize,
                    color: Colors.grey.shade500,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                String? badgeOverride;
                final appStatus = controller.selectedStatus.value;

                if (appStatus == 'Achievable') {
                  badgeOverride = 'Achievable';
                } else if (appStatus == 'Not Achievable' ||
                    appStatus == 'not Achievable') {
                  badgeOverride = 'Not Achievable';
                } else if (appStatus == 'Capacity') {
                  badgeOverride = 'Capacity';
                }

                return OrderCard(
                  order: order,
                  customBadge: badgeOverride,
                  onTap:
                      (order.status == 'Pending Planning' ||
                          order.status == 'In Production')
                      ? () {
                          controller.selectOrder(order);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderDetailScreen(),
                            ),
                          );
                        }
                      : null,
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.kColorPrimary),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 56,
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.kColorSecondary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              onChanged: (val) {
                controller.clearPreloadedOrders();
                controller.searchQuery.value = val;
              },
              style: TextStyles.kRegularDongle(fontSize: FontSizes.k24FontSize),
              decoration: InputDecoration(
                hintText: 'Search orders, customers...',
                hintStyle: TextStyles.kRegularDongle(
                  fontSize: FontSizes.k24FontSize,
                  color: AppColors.kColorGrey,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilterButton() {
    return Obx(() {
      final isDateSelected =
          controller.selectedDate.value != null ||
          (controller.dateFrom.value != null);
      return InkWell(
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: controller.selectedDate.value ?? DateTime(2026, 1, 22),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          if (pickedDate != null) {
            controller.clearPreloadedOrders();
            controller.selectDate(pickedDate);
          }
        },
        onLongPress: () {
          controller.clearDate();
          Get.snackbar(
            'Filters Cleared',
            'Showing all dates',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
          );
        },
        child: Container(
          height: AppScreenUtils.isWeb ? 40 : 48,
          width: AppScreenUtils.isWeb ? 40 : 48,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isDateSelected
                  ? AppColors.kColorSecondary
                  : AppColors.kColorPrimary,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.calendar_month,
                color: AppColors.kColorSecondary,
                size: AppScreenUtils.isWeb ? 20 : 28,
              ),
              if (isDateSelected)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.kColorRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatusDropdown() {
    return Obx(
      () => Container(
        height: AppScreenUtils.isWeb ? 40 : 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.kColorPrimary),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedStatus.value,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            menuMaxHeight: 300,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.kColorSecondary,
              size: AppScreenUtils.isWeb ? 20 : 28,
            ),
            items: controller.statusList.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(
                  status,
                  style: TextStyles.kBoldDongle(
                    fontSize: FontSizes.k22FontSize,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                controller.clearPreloadedOrders();
                controller.selectedStatus.value = val;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCylinderDropdown() {
    return Obx(
      () => Container(
        height: AppScreenUtils.isWeb ? 40 : 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.kColorPrimary),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedCylinder.value,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.kColorSecondary,
              size: AppScreenUtils.isWeb ? 20 : 28,
            ),
            items: controller.cylinderList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyles.kBoldDongle(
                    fontSize: FontSizes.k22FontSize,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                controller.clearPreloadedOrders();
                controller.selectedCylinder.value = val;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Obx(
      () => Container(
        height: AppScreenUtils.isWeb ? 40 : 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.kColorPrimary),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedSort.value,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.kColorSecondary,
              size: AppScreenUtils.isWeb ? 20 : 28,
            ),
            items: controller.sortList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyles.kBoldDongle(
                    fontSize: FontSizes.k22FontSize,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) controller.selectedSort.value = val;
            },
          ),
        ),
      ),
    );
  }
}

// Order Detail Screen remains mostly the same but with web-optimized layout
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TotalOrdersController>();
    final isWeb = AppScreenUtils.isWeb || AppScreenUtils.isTablet(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isWeb
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.kColorSecondary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Obx(() {
                final order = controller.selectedOrder.value;
                if (order == null) return const SizedBox();
                return Text(
                  order.status == 'In Production'
                      ? 'Production Status'
                      : 'Detailed Planning',
                  style: TextStyles.kBoldDongle(
                    fontSize: FontSizes.k20FontSize,
                    color: AppColors.kColorSecondary,
                  ),
                );
              }),
            ),
      body: isWeb
          ? _buildWebDetailLayout(context, controller)
          : _buildMobileDetailLayout(controller),
    );
  }

  Widget _buildWebDetailLayout(
    BuildContext context,
    TotalOrdersController controller,
  ) {
    return Column(
      children: [
        // Header (Matching Dashboard/Total Orders Style)
        Container(
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.kColorSecondary,
                  size: 28,
                ),
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 16),
              Obx(() {
                final order = controller.selectedOrder.value;
                if (order == null) return const SizedBox();
                return Text(
                  order.status == 'In Production'
                      ? 'Production Status'
                      : 'Detailed Planning',
                  style: TextStyles.kBoldDongle(
                    fontSize: 36,
                    color: AppColors.kColorSecondary,
                  ),
                );
              }),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.kColorSecondary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        // Top Panel - Order Data (Horizontal)
        Obx(() {
          final order = controller.selectedOrder.value;
          if (order == null) return const SizedBox();
          return _buildOrderDataTable(order);
        }),
        // Bottom Panel - Factors
        Expanded(
          child: Container(
            color: Colors.grey.shade50,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Obx(() {
                final order = controller.selectedOrder.value;
                if (order == null) return const SizedBox();

                if (controller.viewingFactorIndex.value != 0) {
                  return _buildFactorDetailInPlace(context, order, controller);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.status == 'In Production'
                          ? 'Order Progress'
                          : 'Planning Factors',
                      style: TextStyles.kBoldDongle(
                        fontSize: 28,
                        color: AppColors.kColorPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFactorItem(
                      context,
                      index: 1,
                      title: 'Production Capacity',
                      icon: Icons.factory_outlined,
                      iconColor: Colors.blue,
                      isComplete: controller.isFactor1Complete.value,
                      controller: controller,
                    ),
                    _buildFactorItem(
                      context,
                      index: 2,
                      title: 'Cylinder Availability',
                      icon: Icons.storage_outlined,
                      iconColor: Colors.purple,
                      isComplete: controller.isFactor2Complete.value,
                      controller: controller,
                    ),
                    _buildFactorItem(
                      context,
                      index: 3,
                      title: 'Raw Material',
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.teal,
                      isComplete: controller.isFactor3Complete.value,
                      controller: controller,
                    ),
                    if (order.status != 'In Production')
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed:
                                (controller.isFactor1Complete.value &&
                                    controller.isFactor2Complete.value &&
                                    controller.isFactor3Complete.value)
                                ? () => controller.planOrder()
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (controller.isFactor1Complete.value &&
                                      controller.isFactor2Complete.value &&
                                      controller.isFactor3Complete.value)
                                  ? AppColors.kColorSecondary
                                  : Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'START PRODUCTION',
                              style: TextStyles.kBoldDongle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (order.status == 'In Production') ...[
                      const Divider(height: 48),
                      Text(
                        'Production Phase',
                        style: TextStyles.kBoldDongle(
                          fontSize: 22,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFactorItem(
                        context,
                        index: 4,
                        title: 'Production Issues',
                        icon: Icons.report_problem_outlined,
                        iconColor: Colors.red,
                        isComplete: controller.isFactor4Complete.value,
                        controller: controller,
                      ),
                      _buildFactorItem(
                        context,
                        index: 5,
                        title: 'Delivery Verification',
                        icon: Icons.local_shipping_outlined,
                        iconColor: Colors.orange,
                        isComplete: controller.isFactor5Complete.value,
                        controller: controller,
                      ),
                      if (controller.isFactor4Complete.value &&
                          controller.isFactor5Complete.value)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () => controller.completeProduction(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.kColorSecondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'CONFIRM ORDER',
                                style: TextStyles.kBoldDongle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileDetailLayout(TotalOrdersController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final order = controller.selectedOrder.value;
        if (order == null) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            OrderCard(order: order),
            const SizedBox(height: 24),
            if (controller.viewingFactorIndex.value != 0)
              _buildFactorDetailInPlace(Get.context!, order, controller)
            else ...[
              Text(
                order.status == 'In Production'
                    ? 'Order Progress'
                    : 'Planning Factors',
                style: TextStyles.kBoldDongle(
                  fontSize: FontSizes.k18FontSize,
                  color: AppColors.kColorPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildFactorItem(
                Get.context!,
                index: 1,
                title: 'Production Capacity',
                icon: Icons.factory_outlined,
                iconColor: Colors.blue,
                isComplete: controller.isFactor1Complete.value,
                controller: controller,
              ),
              _buildFactorItem(
                Get.context!,
                index: 2,
                title: 'Cylinder Availability',
                icon: Icons.storage_outlined,
                iconColor: Colors.purple,
                isComplete: controller.isFactor2Complete.value,
                controller: controller,
              ),
              _buildFactorItem(
                Get.context!,
                index: 3,
                title: 'Raw Material',
                icon: Icons.inventory_2_outlined,
                iconColor: Colors.teal,
                isComplete: controller.isFactor3Complete.value,
                controller: controller,
              ),
              if (order.status != 'In Production')
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          (controller.isFactor1Complete.value &&
                              controller.isFactor2Complete.value &&
                              controller.isFactor3Complete.value)
                          ? () => controller.planOrder()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (controller.isFactor1Complete.value &&
                                controller.isFactor2Complete.value &&
                                controller.isFactor3Complete.value)
                            ? Colors.indigo
                            : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'START PRODUCTION',
                        style: TextStyles.kBoldDongle(
                          fontSize: FontSizes.k16FontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              if (order.status == 'In Production') ...[
                const Divider(height: 32),
                Text(
                  'Production Phase',
                  style: TextStyles.kMediumDongle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFactorItem(
                  Get.context!,
                  index: 4,
                  title: 'Production Issues',
                  icon: Icons.report_problem_outlined,
                  iconColor: Colors.red,
                  isComplete: controller.isFactor4Complete.value,
                  controller: controller,
                ),
                _buildFactorItem(
                  Get.context!,
                  index: 5,
                  title: 'Delivery Verification',
                  icon: Icons.local_shipping_outlined,
                  iconColor: Colors.orange,
                  isComplete: controller.isFactor5Complete.value,
                  controller: controller,
                ),
                if (controller.isFactor4Complete.value &&
                    controller.isFactor5Complete.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => controller.completeProduction(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kColorSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'CONFIRM ORDER',
                          style: TextStyles.kBoldDongle(
                            color: Colors.white,
                            fontSize: FontSizes.k16FontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
            const SizedBox(height: 40),
          ],
        );
      }),
    );
  }

  Widget _buildFactorItem(
    BuildContext context, {
    required int index,
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isComplete,
    required TotalOrdersController controller,
  }) {
    bool isLocked = false;
    String lockReason = "";

    if (index == 2 && !controller.isFactor1Complete.value) {
      isLocked = true;
      lockReason = "Please complete Factor 1: Production Capacity first.";
    } else if (index == 3 && !controller.isFactor2Complete.value) {
      isLocked = true;
      lockReason = "Please complete Factor 2: Cylinder Availability first.";
    } else if (index == 4 && !controller.isFactor3Complete.value) {
      isLocked = true;
      lockReason = "Please complete Factor 3: Raw Material first.";
    } else if (index == 5 && !controller.isFactor4Complete.value) {
      isLocked = true;
      lockReason = "Please complete Factor 4: Production Issues first.";
    }

    bool isFrozenCompleted = false;

    if (controller.currentOrder.status == 'In Production' && index <= 3) {
      isFrozenCompleted = true;
    }

    final isWeb = AppScreenUtils.isWeb || AppScreenUtils.isTablet(context);

    return InkWell(
      onTap: isFrozenCompleted
          ? null
          : () {
              if (isLocked) {
                Get.snackbar(
                  'Locked Phase',
                  lockReason,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.amber.shade700,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 8,
                  duration: const Duration(seconds: 2),
                  icon: const Icon(Icons.lock_outline, color: Colors.white),
                );
                return;
              }

              controller.viewingFactorIndex.value = index;
            },
      child: Opacity(
        opacity: isLocked ? 0.4 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: (index == 3 && controller.isFactor3Waiting.value)
                            ? Colors.orange
                            : (index == 4 && controller.hasFactor4Issue.value)
                            ? Colors.red
                            : (isComplete
                                  ? Colors.green
                                  : (isLocked
                                        ? Colors.transparent
                                        : Colors.grey.shade300)),
                        shape: BoxShape.circle,
                        border: isLocked
                            ? Border.all(color: Colors.grey.shade400)
                            : null,
                      ),
                      child: Center(
                        child: (index == 4 && controller.hasFactor4Issue.value)
                            ? const Icon(
                                Icons.priority_high,
                                size: 14,
                                color: Colors.white,
                              )
                            : (isComplete
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : (isLocked
                                        ? Icon(
                                            Icons.lock_outline,
                                            size: 12,
                                            color: Colors.grey.shade500,
                                          )
                                        : const SizedBox())),
                      ),
                    ),
                    if (index < 5)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isComplete
                              ? Colors.green
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: iconColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: TextStyles.kBoldDongle(
                              fontSize: isWeb
                                  ? FontSizes.k15FontSize
                                  : FontSizes.k14FontSize,
                              color: isComplete
                                  ? Colors.green.shade700
                                  : (isLocked
                                        ? Colors.grey.shade500
                                        : Colors.black87),
                            ),
                          ),
                          const Spacer(),
                          if (!isFrozenCompleted)
                            Icon(
                              isLocked
                                  ? Icons.lock_outline
                                  : Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.grey.shade400,
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFactorDetailInPlace(
    BuildContext context,
    Order order,
    TotalOrdersController controller,
  ) {
    int index = controller.viewingFactorIndex.value;
    String title = "";
    switch (index) {
      case 1:
        title = 'Production Capacity';
        break;
      case 2:
        title = 'Cylinder Availability';
        break;
      case 3:
        title = 'Raw Material';
        break;
      case 4:
        title = 'Production Issues';
        break;
      case 5:
        title = 'Delivery Verification';
        break;
    }

    bool isReadOnly = false;
    if (order.status == 'In Production' && index <= 3) {
      isReadOnly = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.kColorSecondary,
              ),
              onPressed: () => controller.viewingFactorIndex.value = 0,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyles.kBoldDongle(
                fontSize: 28,
                color: AppColors.kColorPrimary,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(
            (AppScreenUtils.isWeb || AppScreenUtils.isTablet(context))
                ? 32
                : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: (AppScreenUtils.isWeb || AppScreenUtils.isTablet(context))
                ? Border.all(color: Colors.grey.shade200)
                : null,
            boxShadow:
                (AppScreenUtils.isWeb || AppScreenUtils.isTablet(context))
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: fds.FactorDetailScreen(
            order: order,
            factorIndex: index,
            title: title,
            isReadOnly: isReadOnly,
            showAppBar: false,
            showCard: false,
            onBack: () => controller.viewingFactorIndex.value = 0,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDataTable(Order order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Table Header (Matching OrdersTable)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.kColorPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildHeaderCell('ORDER NO', 2),
                _buildHeaderCell('CAPACITY', 1),
                _buildHeaderCell('PROPORTION', 3),
                _buildHeaderCell('ORDER DATE', 2),
                _buildHeaderCell('DELIVERY DATE', 2),
                _buildHeaderCell('DAYS', 1),
                _buildHeaderCell('CYLINDER', 2),
                _buildHeaderCell('STATUS', 2),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Data Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                _buildDataCell(order.id, 2, isBold: true),
                _buildDataCell(order.quantity.toString(), 1),
                _buildDataCell(order.proportion, 3),
                _buildDataCell(
                  DateFormat('dd/MM/yyyy').format(order.orderDate),
                  2,
                ),
                _buildDataCell(
                  DateFormat('dd/MM/yyyy').format(order.deliveryDate),
                  2,
                ),
                _buildDataCell(
                  order.productionDays.toString(),
                  1,
                  color: Colors.pink,
                ),
                _buildDataCell(order.cylinderType, 2),
                Expanded(flex: 2, child: _buildStatusBadge(order)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, int flex) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          label,
          style: TextStyles.kBoldDongle(
            fontSize: 26,
            color: AppColors.kColorSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String value,
    int flex, {
    bool isBold = false,
    Color? color,
  }) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          value,
          style: isBold
              ? TextStyles.kBoldDongle(
                  fontSize: 23.5,
                  color: color ?? AppColors.kColorSecondary,
                )
              : TextStyles.kRegularDongle(
                  fontSize: 23.5,
                  color: color ?? Colors.black87,
                ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Order order) {
    String statusText = order.status;
    Color badgeBgColor;
    Color badgeTextColor;

    // Standard Status Logic
    switch (order.status) {
      case 'In Production':
        badgeBgColor = const Color(0xFFFFF3E0);
        badgeTextColor = const Color(0xFFEF6C00);
        break;
      case 'Delivered':
        badgeBgColor = const Color(0xFFE8F5E9);
        badgeTextColor = const Color(0xFF2E7D32);
        break;
      case 'Hold/Stuck':
        badgeBgColor = const Color(0xFFFCE4EC);
        badgeTextColor = const Color(0xFFC2185B);
        break;
      case 'Due':
      case 'Delivery Due':
        badgeBgColor = const Color(0xFFFFEBEE);
        badgeTextColor = const Color(0xFFC62828);
        break;
      case 'Not Due':
        badgeBgColor = const Color(0xFFE3F2FD);
        badgeTextColor = const Color(0xFF1565C0);
        break;
      case 'Pending Planning':
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
        border: Border.all(color: badgeTextColor.withValues(alpha: 0.1)),
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
