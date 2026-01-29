import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/text_styles.dart';

class WebSidebar extends StatelessWidget {
  final String activeRoute; // 'dashboard', 'total_orders', 'pending_planning'
  final int totalOrdersCount;
  final int pendingCount;
  final VoidCallback? onDashboardTap;
  final VoidCallback? onTotalOrdersTap;
  final VoidCallback? onPendingPlanningTap;

  const WebSidebar({
    super.key,
    required this.activeRoute,
    this.totalOrdersCount = 0,
    this.pendingCount = 0,
    this.onDashboardTap,
    this.onTotalOrdersTap,
    this.onPendingPlanningTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.kColorSecondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Vadilal',
                style: TextStyles.kBoldDongle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
          ),

          // Dashboard Item
          _buildSidebarItem(
            label: 'Dashboard',
            icon: Icons.dashboard,
            isSelected: activeRoute == 'dashboard',
            onTap: onDashboardTap,
          ),

          // Total Orders Item
          _buildSidebarItem(
            label: 'Total Orders',
            icon: Icons.list_alt,
            isSelected: activeRoute == 'total_orders',
            onTap: onTotalOrdersTap,
            badgeCount: totalOrdersCount,
          ),

          // Pending Planning Item
          _buildSidebarItem(
            label: 'Pending Planning',
            icon: Icons.pending_actions,
            isSelected: activeRoute == 'pending_planning',
            onTap: onPendingPlanningTap,
            badgeCount: pendingCount,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onTap,
    int badgeCount = 0,
  }) {
    return ListTile(
      onTap: onTap,
      tileColor: isSelected
          ? AppColors.kColorSecondary.withValues(alpha: 0.1)
          : null,
      leading: Icon(
        icon,
        color: isSelected ? AppColors.kColorSecondary : Colors.grey.shade600,
      ),
      title: Row(
        children: [
          Text(
            label,
            style: isSelected
                ? TextStyles.kBoldDongle(
                    fontSize: 18,
                    color: AppColors.kColorSecondary,
                  )
                : TextStyles.kMediumDongle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
          ),
          if (badgeCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.timelinePending,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$badgeCount',
                style: TextStyles.kBoldDongle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
    );
  }
}
