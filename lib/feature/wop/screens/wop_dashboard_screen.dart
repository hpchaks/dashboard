import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/feature/wop/screens/total_orders_screen.dart';
import 'package:dashboard/feature/wop/controllers/dashboard_controller.dart';
import 'package:dashboard/styles/text_styles.dart';

import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';
import 'package:get/get.dart';

class StatusConfig {
  final Color color;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;

  StatusConfig({
    required this.color,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
  });
}

class WOPDashboardScreen extends StatelessWidget {
  const WOPDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    final Map<String, StatusConfig> statusConfig = {
      'Planned': StatusConfig(
        color: AppColors.timelinePlanned.withValues(alpha: 0.5),
        bgColor: AppColors.timelinePlanned.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelinePlanned.withValues(alpha: 0.3),
      ),
      'Pending Planning': StatusConfig(
        color: AppColors.timelinePending.withValues(alpha: 0.5),
        bgColor: AppColors.timelinePending.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelinePending.withValues(alpha: 0.3),
      ),
      'In Production': StatusConfig(
        color: AppColors.timelineInProduction.withValues(alpha: 0.5),
        bgColor: AppColors.timelineInProduction.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineInProduction.withValues(alpha: 0.3),
      ),
      'Due': StatusConfig(
        color: AppColors.timelineDue.withValues(alpha: 0.5),
        bgColor: AppColors.timelineDue.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineDue.withValues(alpha: 0.3),
      ),
      'Delivered': StatusConfig(
        color: AppColors.timelineDelivered.withValues(alpha: 0.5),
        bgColor: AppColors.timelineDelivered.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineDelivered.withValues(alpha: 0.3),
      ),
      'Not Due': StatusConfig(
        color: AppColors.timelineNotDue.withValues(alpha: 0.5),
        bgColor: AppColors.timelineNotDue.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineNotDue.withValues(alpha: 0.3),
      ),
      'Hold/Stuck': StatusConfig(
        color: AppColors.timelineHold.withValues(alpha: 0.5),
        bgColor: AppColors.timelineHold.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineHold.withValues(alpha: 0.3),
      ),
      'Delivery Due': StatusConfig(
        color: AppColors.timelineDeliveryDue.withValues(alpha: 0.5),
        bgColor: AppColors.timelineDeliveryDue.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineDeliveryDue.withValues(alpha: 0.3),
      ),
      'Achievable': StatusConfig(
        color: AppColors.timelineAchievable.withValues(alpha: 0.5),
        bgColor: AppColors.timelineAchievable.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineAchievable.withValues(alpha: 0.3),
      ),
      'not Achievable': StatusConfig(
        color: AppColors.timelineNotAchievable.withValues(alpha: 0.5),
        bgColor: AppColors.timelineNotAchievable.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineNotAchievable.withValues(alpha: 0.3),
      ),
      'Capacity': StatusConfig(
        color: AppColors.timelineCapacity.withValues(alpha: 0.5),
        bgColor: AppColors.timelineCapacity.withValues(alpha: 0.15),
        textColor: AppColors.timelineText,
        borderColor: AppColors.timelineCapacity.withValues(alpha: 0.3),
      ),
    };

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: AppScreenUtils.isWeb
              ? _buildWebLayout(context, controller, statusConfig)
              : _buildMobileLayout(context, controller, statusConfig),
        ),
      ),
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    DashboardController controller,
    Map<String, StatusConfig> statusConfig,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dashboard",
                      style: TextStyles.kBoldDongle(
                        fontSize: 36,
                        color: AppColors.kColorSecondary,
                      ),
                    ),
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
                const SizedBox(height: 32),

                // Full Width Search Bar
                _buildFullSearchBar(),
                const SizedBox(height: 20),

                // Filters Row: From Date, To Date, Quick Filters
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildDateBox(
                        context,
                        "From Date",
                        controller.dateFrom,
                        (date) => controller.updateDateRange(date, null),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _buildDateBox(
                        context,
                        "To Date",
                        controller.dateTo,
                        (date) => controller.updateDateRange(null, date),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: _buildWebQuickFilters(controller)),
                  ],
                ),
                const SizedBox(height: 32),

                // Metrics Cards Grid (8 cards total)
                _buildWebMetricsGrid(context, controller),
                const SizedBox(height: 32),

                // Calendar View
                _buildCalendarView(context, controller, statusConfig),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    DashboardController controller,
    Map<String, StatusConfig> statusConfig,
  ) {
    return Column(
      children: [
        _buildMobileAppBar(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildDateFilters(context, controller),
                const SizedBox(height: 16),
                _buildMetricsCards(context, controller),
                const SizedBox(height: 16),
                _buildCalendarView(context, controller, statusConfig),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.kColorSecondary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              style: TextStyles.kRegularDongle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search orders, customers, or products...',
                hintStyle: TextStyles.kRegularDongle(
                  fontSize: 16,
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

  Widget _buildWebQuickFilters(DashboardController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Quick Filter",
            style: TextStyles.kMediumDongle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.quickFilter.value,
                isExpanded: true,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.kColorSecondary,
                  size: 24,
                ),
                style: TextStyles.kBoldDongle(
                  fontSize: 24,
                  color: Colors.black87,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'this week',
                    child: Text('This Week'),
                  ),
                  DropdownMenuItem(
                    value: 'this month',
                    child: Text('This Month'),
                  ),
                  DropdownMenuItem(
                    value: 'this year',
                    child: Text('This Year'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.handleQuickFilter(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebMetricsGrid(
    BuildContext context,
    DashboardController controller,
  ) {
    return Obx(() {
      final metrics = controller.metrics;

      final List<Map<String, dynamic>> items = [
        {
          'label': 'Due',
          'count': metrics['due'],
          'status': 'Due',
          'color': AppColors.timelineDue,
          'useDate': false,
        },
        {
          'label': 'Not Due',
          'count': metrics['notDue'],
          'status': 'Not Due',
          'color': AppColors.timelineNotDue,
          'useDate': true,
        },
        // Planned Group
        {
          'label': 'Planned',
          'count': metrics['planned'],
          'status': 'Planned',
          'color': AppColors.timelinePlanned,
          'useDate': true,
        },
        {
          'label': 'In Production',
          'count': metrics['inProduction'],
          'status': 'In Production',
          'color': AppColors.timelineInProduction,
          'useDate': true,
        },
        {
          'label': 'Delivered',
          'count': metrics['delivered'],
          'status': 'Delivered',
          'color': AppColors.timelineDelivered,
          'useDate': true,
        },
        {
          'label': 'Hold/Stuck',
          'count': metrics['holdStuck'],
          'status': 'Hold/Stuck',
          'color': AppColors.timelineHold,
          'useDate': true,
        },
      ];

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildWebMetricCard(
            context: context,
            label: item['label'],
            count: item['count'].toString(),
            color: item['color'] ?? AppColors.kColorPrimary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TotalOrdersScreen(
                    initialStatus: item['status'],
                    initialDateFrom: item['useDate']
                        ? controller.dateFrom.value
                        : null,
                    initialDateTo: item['useDate']
                        ? controller.dateTo.value
                        : null,
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  Widget _buildWebMetricCard({
    required BuildContext context,
    required String label,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count,
                    style: TextStyles.kBoldDongle(fontSize: 36, color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyles.kMediumDongle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateBox(
    BuildContext context,
    String label,
    Rx<DateTime> dateObs,
    Function(DateTime) onDateSelected,
  ) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: dateObs.value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              onDateSelected(date);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyles.kMediumDongle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      DateFormat('dd MMM yyyy').format(dateObs.value),
                      style: TextStyles.kBoldDongle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.kColorSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.kColorSecondary,
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Text(
              'Dashboard',
              style: TextStyles.kBoldDongle(
                color: AppColors.kColorSecondary,
                fontSize: FontSizes.k24FontSize,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
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
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyles.kRegularDongle(fontSize: FontSizes.k14FontSize),
              decoration: InputDecoration(
                hintText: 'Search orders, customers, or products...',
                hintStyle: TextStyles.kRegularDongle(
                  fontSize: FontSizes.k14FontSize,
                  color: AppColors.kColorGrey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          Icon(Icons.search, color: AppColors.kColorSecondary),
        ],
      ),
    );
  }

  Widget _buildDateFilters(
    BuildContext context,
    DashboardController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Date Range',
                style: TextStyles.kSemiBoldDongle(
                  fontSize: FontSizes.k14FontSize,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0, left: 3.0),
                      child: Text(
                        'From Date',
                        style: TextStyles.kMediumDongle(
                          fontSize: FontSizes.k14FontSize,
                          color: AppColors.kColorSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: controller.dateFrom.value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          controller.updateDateRange(date, null);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.kColorPrimary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Obx(
                                () => Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(controller.dateFrom.value),
                                  style: TextStyles.kRegularDongle(
                                    fontSize: FontSizes.k14FontSize,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0, left: 3.0),
                      child: Text(
                        'To Date',
                        style: TextStyles.kMediumDongle(
                          fontSize: FontSizes.k14FontSize,
                          color: AppColors.kColorSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: controller.dateTo.value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          controller.updateDateRange(null, date);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.kColorPrimary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Obx(
                                () => Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(controller.dateTo.value),
                                  style: TextStyles.kRegularDongle(
                                    fontSize: FontSizes.k14FontSize,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildQuickFilterButton('this week', controller)),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickFilterButton('this month', controller),
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildQuickFilterButton('this year', controller)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterButton(
    String filter,
    DashboardController controller,
  ) {
    return Obx(() {
      final isSelected = controller.quickFilter.value == filter;
      return InkWell(
        onTap: () => controller.handleQuickFilter(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.kColorPrimary : Colors.white,
            border: Border.all(
              color: isSelected
                  ? AppColors.kColorPrimary
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            filter.capitalizeFirst!,
            textAlign: TextAlign.center,
            style: TextStyles.kMediumDongle(
              fontSize: FontSizes.k10FontSize,
              color: isSelected ? Colors.white : AppColors.kColorPrimary,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMetricsCards(
    BuildContext context,
    DashboardController controller,
  ) {
    return Obx(() {
      final metrics = controller.metrics;

      final List<Map<String, dynamic>> items = [
        {
          'label': 'Pending',
          'count': metrics['pending'],
          'status': 'Pending Planning',
          'color': AppColors.timelinePending,
          'useDate': false,
        },
        {
          'label': 'Due',
          'count': metrics['due'],
          'status': 'Due',
          'color': AppColors.timelineDue,
          'useDate': false,
        },
        {
          'label': 'Not Due',
          'count': metrics['notDue'],
          'status': 'Not Due',
          'color': AppColors.timelineNotDue,
          'useDate': true,
        },
        {
          'label': 'Planned',
          'count': metrics['planned'],
          'status': 'Planned',
          'color': AppColors.timelinePlanned,
          'useDate': true,
        },
        {
          'label': 'In Production',
          'count': metrics['inProduction'],
          'status': 'In Production',
          'color': AppColors.timelineInProduction,
          'useDate': true,
        },
        {
          'label': 'Delivered',
          'count': metrics['delivered'],
          'status': 'Delivered',
          'color': AppColors.timelineDelivered,
          'useDate': true,
        },
        {
          'label': 'Hold/Stuck',
          'count': metrics['holdStuck'],
          'status': 'Hold/Stuck',
          'color': AppColors.timelineHold,
          'useDate': true,
        },
      ];

      return SizedBox(
        height: 110,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildSquareMetricCard(
              context: context,
              label: item['label'],
              count: item['count'].toString(),
              color: item['color'] ?? AppColors.kColorPrimary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TotalOrdersScreen(
                      initialStatus: item['status'],
                      initialDateFrom: item['useDate']
                          ? controller.dateFrom.value
                          : null,
                      initialDateTo: item['useDate']
                          ? controller.dateTo.value
                          : null,
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildSquareMetricCard({
    required BuildContext context,
    required String label,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: TextStyles.kBoldDongle(
                    fontSize: FontSizes.k32FontSize,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyles.kMediumDongle(
                    fontSize: FontSizes.k14FontSize,
                    color: AppColors.kColorPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView(
    BuildContext context,
    DashboardController controller,
    Map<String, StatusConfig> statusConfig,
  ) {
    final isWeb = AppScreenUtils.isWeb || AppScreenUtils.isTablet(context);

    return Container(
      padding: EdgeInsets.all(isWeb ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isWeb ? Border.all(color: Colors.grey.shade200) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: isWeb ? 24 : 20,
                      color: AppColors.kColorSecondary,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Production Timeline',
                        style: TextStyles.kBoldDongle(
                          fontSize: isWeb ? 22 : FontSizes.k16FontSize,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => controller.navigateWeek(-1),
                    child: Container(
                      padding: EdgeInsets.all(isWeb ? 12 : 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: isWeb ? 24 : 20,
                        color: AppColors.kColorPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => controller.navigateWeek(1),
                    child: Container(
                      padding: EdgeInsets.all(isWeb ? 12 : 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        size: isWeb ? 24 : 20,
                        color: AppColors.kColorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isWeb ? 24 : 16),

          // Scrollable Date Cards
          SizedBox(
            height: isWeb ? 280 : 200,
            child: Obx(() {
              final weekDates = controller.weekDates;

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

                  final isDateInRange = date.day >= 18 && date.day <= 24;

                  final timelineOrders = controller.getTimelineDetailedOrders(
                    weekDates,
                  );
                  final dateKey = "${date.year}-${date.month}-${date.day}";

                  final prodList =
                      timelineOrders['${dateKey}_Production'] ?? [];
                  final capList = timelineOrders['${dateKey}_Capacity'] ?? [];
                  final dueList = timelineOrders['${dateKey}_Due'] ?? [];
                  final achList = timelineOrders['${dateKey}_Achievable'] ?? [];
                  final notAchList =
                      timelineOrders['${dateKey}_NotAchievable'] ?? [];
                  final delList = timelineOrders['${dateKey}_Delivered'] ?? [];

                  int prodCount = prodList.length;
                  int capacityCount = capList.length;
                  int deliveryDueCount = dueList.length;
                  int deliveredCount = delList.length;
                  int achievable = achList.length;
                  int notAchievable = notAchList.length;

                  Widget buildMiniChip(
                    String label,
                    int value,
                    String statusKey, {
                    VoidCallback? onTap,
                  }) {
                    final config =
                        statusConfig[statusKey] ??
                        statusConfig['In Production'] ??
                        statusConfig['Pending']!;

                    return InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: isWeb ? 60 : 42,
                        height: isWeb ? 60 : 42,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: config.bgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: config.borderColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$value',
                              style: TextStyles.kBoldDongle(
                                fontSize: isWeb ? 18 : FontSizes.k13FontSize,
                                color: config.textColor,
                              ),
                            ),
                            Text(
                              label,
                              style: TextStyles.kRegularDongle(
                                fontSize: isWeb ? 11 : 8,
                                color: config.textColor.withValues(alpha: 0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Container(
                    width: isWeb ? 180 : 130,
                    margin: EdgeInsets.only(
                      right: index < 6 ? (isWeb ? 16 : 10) : 0,
                    ),
                    padding: EdgeInsets.all(isWeb ? 16 : 10),
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.blue.withValues(alpha: 0.04)
                          : Colors.grey.shade50,
                      border: Border.all(
                        color: isToday
                            ? Colors.blue.withValues(alpha: 0.15)
                            : Colors.grey.shade200,
                        width: isWeb ? 2 : 2,
                      ),
                      borderRadius: BorderRadius.circular(isWeb ? 16 : 12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dayName,
                              style: TextStyles.kMediumDongle(
                                fontSize: isWeb ? 16 : FontSizes.k14FontSize,
                                color: isToday
                                    ? Colors.blue.shade600
                                    : Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              '$dayNum',
                              style: TextStyles.kBoldDongle(
                                fontSize: isWeb ? 24 : FontSizes.k18FontSize,
                                color: isToday
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isWeb ? 12 : 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!isDateInRange)
                                    const SizedBox.shrink()
                                  else if (prodCount == 0 &&
                                      capacityCount == 0 &&
                                      deliveryDueCount == 0 &&
                                      deliveredCount == 0)
                                    const SizedBox.shrink()
                                  else ...[
                                    if (prodCount > 0 || capacityCount > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (prodCount > 0)
                                              buildMiniChip(
                                                'Prod',
                                                prodCount,
                                                'In Production',
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TotalOrdersScreen(
                                                            initialDate: date,
                                                            initialStatus:
                                                                'In Production',
                                                            preloadedOrders:
                                                                prodList,
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            const SizedBox(width: 4),
                                            if (capacityCount > 0)
                                              buildMiniChip(
                                                'Cap',
                                                capacityCount,
                                                'Capacity',
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TotalOrdersScreen(
                                                            initialDate: date,
                                                            initialStatus:
                                                                'Capacity',
                                                            preloadedOrders:
                                                                capList,
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                    if (deliveryDueCount > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: buildMiniChip(
                                          'Del Due',
                                          deliveryDueCount,
                                          'Delivery Due',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TotalOrdersScreen(
                                                      initialDate: date,
                                                      initialStatus:
                                                          'Delivery Due',
                                                      preloadedOrders: dueList,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    if (deliveryDueCount > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            buildMiniChip(
                                              'Ach',
                                              achievable,
                                              'Achievable',
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TotalOrdersScreen(
                                                          initialDate: date,
                                                          initialStatus:
                                                              'Achievable',
                                                          preloadedOrders:
                                                              achList,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            buildMiniChip(
                                              'Not',
                                              notAchievable,
                                              'not Achievable',
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TotalOrdersScreen(
                                                          initialDate: date,
                                                          initialStatus:
                                                              'Not Achievable',
                                                          preloadedOrders:
                                                              notAchList,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (deliveredCount > 0)
                                      buildMiniChip(
                                        'Done',
                                        deliveredCount,
                                        'Delivered',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TotalOrdersScreen(
                                                    initialDate: date,
                                                    initialStatus: 'Delivered',
                                                    preloadedOrders: delList,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(height: isWeb ? 24 : 16),
          Wrap(
            spacing: isWeb ? 16 : 12,
            runSpacing: isWeb ? 12 : 10,
            children:
                [
                  'In Production',
                  'Capacity',
                  'Delivery Due',
                  'Achievable',
                  'not Achievable',
                  'Delivered',
                ].map((status) {
                  final config =
                      statusConfig[status] ?? statusConfig['Pending']!;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: isWeb ? 16 : 14,
                        height: isWeb ? 16 : 14,
                        decoration: BoxDecoration(
                          color: config.bgColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: config.borderColor),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyles.kMediumDongle(
                          fontSize: isWeb ? 14 : FontSizes.k11FontSize,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
          Obx(() {
            if (controller.selectedStatus.value != null) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_alt,
                        size: 12,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Filter: ${controller.selectedStatus.value}',
                        style: TextStyles.kSemiBoldDongle(
                          fontSize: FontSizes.k10FontSize,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => controller.setSelectedStatus(null),
                        child: Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

class WOPAppBar extends StatelessWidget {
  final String title;
  final bool showSearchBar;
  final Rx<DateTime?>? selectedDate;
  final RxString? selectedStatus;

  const WOPAppBar({
    required this.title,
    this.showSearchBar = true,
    this.selectedDate,
    this.selectedStatus,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kColorSecondary,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    if (selectedDate != null && selectedDate!.value != null) {
                      final date = selectedDate!.value!;
                      return InkWell(
                        onTap: () => selectedDate!.value = null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                DateFormat('dd MMM yyyy').format(date),
                                style: TextStyles.kBoldDongle(
                                  color: AppColors.kColorSecondary,
                                  fontSize: FontSizes.k18FontSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.close,
                              color: AppColors.kColorSecondary,
                              size: 16,
                            ),
                          ],
                        ),
                      );
                    }

                    if (selectedStatus != null &&
                        selectedStatus!.value != 'All Status') {
                      return Text(
                        selectedStatus!.value,
                        style: TextStyles.kBoldDongle(
                          color: AppColors.kColorSecondary,
                          fontSize: FontSizes.k18FontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    }

                    return Text(
                      title,
                      style: TextStyles.kBoldDongle(
                        color: AppColors.kColorSecondary,
                        fontSize: FontSizes.k20FontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.kColorSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
            if (showSearchBar) _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyles.kRegularDongle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyles.kRegularDongle(
                  fontSize: 18,
                  color: AppColors.kColorGrey,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const Icon(Icons.search, color: AppColors.kColorGrey),
        ],
      ),
    );
  }
}
