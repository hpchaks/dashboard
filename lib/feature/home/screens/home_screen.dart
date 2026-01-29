import 'package:flutter/material.dart';
import 'package:dashboard/feature/wop/screens/wop_dashboard_screen.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/styles/font_sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Vadilal',
          style: TextStyles.kBoldDongle(
            color: AppColors.kColorSecondary, // Pinkish Red as per image
            fontSize: FontSizes.k24FontSize,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.kColorSecondary,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.kColorSecondary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '99+',
                    style: TextStyles.kRegularDongle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.person, color: Colors.grey.shade700, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Quick Actions'),
            _buildGrid([
              _GridItem('Attendance', Icons.person_outline),
              _GridItem('Apply Leave', Icons.exit_to_app),
              _GridItem('Unlock\nStatus', Icons.lock_open),
              _GridItem('GPS\nTracking', Icons.location_on_outlined),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader('Entry Section'),
            _buildGrid([
              _GridItem('Visit\nEntry', Icons.location_city),
              _GridItem('Enquiry\nEntry', Icons.assignment_outlined),
              _GridItem('Quotation\nEntry', Icons.request_quote_outlined),
              _GridItem('Order\nEntry', Icons.shopping_cart_outlined),
              _GridItem('Quotation\nCommercial...', Icons.currency_rupee),
              _GridItem('Technical\nEvolution...', Icons.settings_outlined),
              _GridItem('Unlock\nEntry', Icons.lock_open_outlined),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader('Reports'),
            _buildGrid([
              _GridItem('Cylinder\nReport', Icons.propane_tank_outlined),
              _GridItem('Order\nReport', Icons.list_alt),
              _GridItem('Sales\nReport', Icons.bar_chart),
              _GridItem('No Sales\nReport', Icons.money_off),
              _GridItem('Visit/No\nVisit History', Icons.history),
              _GridItem('Date wise\nReport', Icons.calendar_today),
              _GridItem('Activity\nReport', Icons.analytics_outlined),
              _GridItem('Download\nInvoice', Icons.download),
              _GridItem('Download\nCert', Icons.verified_user_outlined),
              _GridItem('Lock\nReport', Icons.lock_clock_outlined),
              _GridItem('Ledger', Icons.book_outlined),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader('Cylinder'),
            _buildGrid([
              _GridItem('Cylinder\nTransaction', Icons.swap_horiz),
              _GridItem('Cylinder\nInformation', Icons.info_outline),
              _GridItem('Authorization', Icons.verified),
              _GridItem('Quality\nAssurance', Icons.shield_outlined),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader('Vehicle'),
            _buildGrid([
              _GridItem('Parameters', Icons.tune),
              _GridItem('QA Check', Icons.checklist),
              _GridItem('Authorise', Icons.check_circle_outlined),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader('WOP'),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WOPDashboardScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.kColorPrimary, // Dark blue
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.checklist_rtl_rounded,
                              color: AppColors.kColorPrimary,
                              size: 28,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyles.kBoldDongle(
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Wop',
                        textAlign: TextAlign.center,
                        style: TextStyles.kSemiBoldDongle(
                          fontSize: FontSizes.k12FontSize,
                          color: AppColors.kColorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: Text(
                'VCL - POR | Admin',
                style: TextStyles.kRegularDongle(
                  color: Colors.grey.shade400,
                  fontSize: FontSizes.k12FontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyles.kBoldDongle(
              fontSize: FontSizes.k18FontSize,
              color: AppColors.kColorPrimary, // Dark Blue
            ),
          ),
          if (title == 'WOP') ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'NEW',
                style: TextStyles.kBoldDongle(
                  fontSize: FontSizes.k10FontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGrid(List<_GridItem> items) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.kColorPrimary.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Icon(
                items[index].icon,
                color: AppColors.kColorPrimary, // Dark blue
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              items[index].label,
              textAlign: TextAlign.center,
              style: TextStyles.kMediumDongle(
                fontSize: FontSizes.k11FontSize,
                color: AppColors.kColorPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}

class _GridItem {
  final String label;
  final IconData icon;

  _GridItem(this.label, this.icon);
}
