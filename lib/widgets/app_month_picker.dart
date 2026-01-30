// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/extensions/app_size_extensions.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppMonthPicker extends StatefulWidget {
  const AppMonthPicker({
    super.key,
    required this.monthYearController,
    required this.hintText,
    this.fillColor,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  final TextEditingController monthYearController;
  final String hintText;
  final Color? fillColor;
  final bool enabled;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;

  @override
  State<AppMonthPicker> createState() => _AppMonthPickerState();
}

class _AppMonthPickerState extends State<AppMonthPicker> {
  static const List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime currentDate =
        _parseMonthYear(widget.monthYearController.text) ?? DateTime.now();

    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return _MonthYearPickerDialog(initialDate: currentDate);
      },
    );

    if (pickedDate != null) {
      setState(() {
        widget.monthYearController.text = _formatMonthYear(pickedDate);
      });

      if (widget.onChanged != null) {
        widget.onChanged!(widget.monthYearController.text);
      }
    }
  }

  DateTime? _parseMonthYear(String monthYearString) {
    try {
      if (monthYearString.isEmpty) return null;

      final parts = monthYearString.split(' ');
      if (parts.length == 2) {
        final monthIndex = monthNames.indexOf(parts[0]) + 1;
        final year = int.parse(parts[1]);
        if (monthIndex > 0 && year > 0) {
          return DateTime(year, monthIndex);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String _formatMonthYear(DateTime date) {
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextFormField(
      controller: widget.monthYearController,
      cursorColor: AppColors.kColorTextPrimary,
      cursorHeight: tablet ? 26 : 20,
      enabled: widget.enabled,
      validator: widget.validator,
      style: TextStyles.kMediumDongle(
        fontSize: tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize,
        color: AppColors.kColorTextPrimary,
      ),
      readOnly: true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyles.kRegularDongle(
          fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
          color: AppColors.kColorDarkGrey,
        ),
        labelText: widget.hintText,
        labelStyle: TextStyles.kRegularDongle(
          fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
          color: AppColors.kColorDarkGrey,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyles.kMediumDongle(
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k18FontSize,
          color: AppColors.kColorPrimary,
        ),
        errorStyle: TextStyles.kRegularDongle(
          fontSize: tablet ? FontSizes.k18FontSize : FontSizes.k14FontSize,
          color: AppColors.kColorRed,
        ),
        border: outlineInputBorder(
          borderColor: AppColors.kColorDarkGrey,
          borderWidth: 1,
          tablet: tablet,
        ),
        enabledBorder: outlineInputBorder(
          borderColor: AppColors.kColorDarkGrey,
          borderWidth: 1,
          tablet: tablet,
        ),
        disabledBorder: outlineInputBorder(
          borderColor: AppColors.kColorDarkGrey,
          borderWidth: 1,
          tablet: tablet,
        ),
        focusedBorder: outlineInputBorder(
          borderColor: AppColors.kColorPrimary,
          borderWidth: 1,
          tablet: tablet,
        ),
        errorBorder: outlineInputBorder(
          borderColor: AppColors.kColorRed,
          borderWidth: 1,
          tablet: tablet,
        ),
        contentPadding: tablet
            ? AppPaddings.combined(horizontal: 20, vertical: 12)
            : AppPaddings.combined(
                horizontal: 16.appWidth,
                vertical: 8.appHeight,
              ),
        filled: true,
        fillColor: widget.fillColor ?? AppColors.kColorWhite,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.calendar_month,
            size: tablet ? 25 : 20,
            color: AppColors.kColorPrimary,
          ),
          onPressed: widget.enabled ? () => _selectMonthYear(context) : null,
        ),
        suffixIconColor: AppColors.kColorPrimary,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color borderColor,
    required double borderWidth,
    required bool tablet,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(tablet ? 20 : 10),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const _MonthYearPickerDialog({required this.initialDate});

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int selectedMonth;
  late int selectedYear;
  late PageController yearPageController;

  static const List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year;
    yearPageController = PageController(initialPage: selectedYear - 2000);
  }

  @override
  void dispose() {
    yearPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: AppColors.kColorPrimary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.kColorPrimary,
          onPrimary: AppColors.kColorWhite,
          surface: AppColors.kColorWhite,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tablet ? 20 : 12),
          ),
        ),
      ),
      child: Transform.scale(
        scale: tablet ? 1.3 : 1.0,
        child: Dialog(
          backgroundColor: AppColors.kColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tablet ? 20 : 10),
          ),
          child: Container(
            width: tablet ? 0.7.screenWidth : 0.85.screenWidth,
            padding: tablet
                ? AppPaddings.combined(horizontal: 30, vertical: 30)
                : AppPaddings.combined(
                    horizontal: 20.appWidth,
                    vertical: 20.appHeight,
                  ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Month & Year',
                  style: TextStyles.kMediumDongle(
                    fontSize: tablet
                        ? FontSizes.k24FontSize
                        : FontSizes.k18FontSize,
                    color: AppColors.kColorTextPrimary,
                  ),
                ),
                SizedBox(height: tablet ? 30 : 20.appHeight),

                // Year Selector
                Container(
                  padding: tablet
                      ? AppPaddings.combined(horizontal: 20, vertical: 16)
                      : AppPaddings.combined(
                          horizontal: 16.appWidth,
                          vertical: 12.appHeight,
                        ),
                  decoration: BoxDecoration(
                    color: AppColors.kColorPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(tablet ? 16 : 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedYear--;
                            yearPageController.animateToPage(
                              selectedYear - 2000,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          color: AppColors.kColorPrimary,
                          size: tablet ? 32 : 24,
                        ),
                      ),
                      SizedBox(
                        height: tablet ? 50 : 40.appHeight,
                        width: tablet ? 150 : 120.appWidth,
                        child: PageView.builder(
                          controller: yearPageController,
                          onPageChanged: (index) {
                            setState(() {
                              selectedYear = 2000 + index;
                            });
                          },
                          itemCount: 101,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Text(
                                '${2000 + index}',
                                style: TextStyles.kMediumDongle(
                                  fontSize: tablet
                                      ? FontSizes.k28FontSize
                                      : FontSizes.k20FontSize,
                                  color: AppColors.kColorPrimary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedYear++;
                            yearPageController.animateToPage(
                              selectedYear - 2000,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        },
                        icon: Icon(
                          Icons.chevron_right,
                          color: AppColors.kColorPrimary,
                          size: tablet ? 32 : 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tablet ? 30 : 20.appHeight),

                // Month Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: tablet ? 15 : 10.appWidth,
                    mainAxisSpacing: tablet ? 15 : 10.appHeight,
                    childAspectRatio: tablet ? 2.0 : 1.8,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final isSelected = month == selectedMonth;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedMonth = month;
                        });
                      },
                      borderRadius: BorderRadius.circular(tablet ? 16 : 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.kColorPrimary
                              : AppColors.kColorWhite,
                          borderRadius: BorderRadius.circular(tablet ? 16 : 10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.kColorPrimary
                                : AppColors.kColorDarkGrey,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            monthNames[index],
                            style: TextStyles.kMediumDongle(
                              fontSize: tablet
                                  ? FontSizes.k20FontSize
                                  : FontSizes.k14FontSize,
                              color: isSelected
                                  ? AppColors.kColorWhite
                                  : AppColors.kColorTextPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: tablet ? 30 : 20.appHeight),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: tablet
                            ? AppPaddings.combined(horizontal: 24, vertical: 12)
                            : AppPaddings.combined(
                                horizontal: 16.appWidth,
                                vertical: 8.appHeight,
                              ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyles.kMediumDongle(
                          fontSize: tablet
                              ? FontSizes.k20FontSize
                              : FontSizes.k16FontSize,
                          color: AppColors.kColorTextPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: tablet ? 16 : 12.appWidth),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          DateTime(selectedYear, selectedMonth, 1),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kColorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(tablet ? 16 : 10),
                        ),
                        padding: tablet
                            ? AppPaddings.combined(horizontal: 32, vertical: 12)
                            : AppPaddings.combined(
                                horizontal: 24.appWidth,
                                vertical: 4.appHeight,
                              ),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyles.kMediumDongle(
                          fontSize: tablet
                              ? FontSizes.k20FontSize
                              : FontSizes.k16FontSize,
                          color: AppColors.kColorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
