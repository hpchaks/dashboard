import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/extensions/app_size_extensions.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppDatePickerTextFormField extends StatefulWidget {
  const AppDatePickerTextFormField({
    super.key,
    required this.dateController,
    this.floatingLabelRequired,
    required this.hintText,
    this.fillColor,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.minDate, // ✅ NEW: Minimum selectable date
  });

  final TextEditingController dateController;
  final bool? floatingLabelRequired;
  final String hintText;
  final Color? fillColor;
  final bool enabled;
  final String? Function(String? value)? validator;
  final DateTime? minDate; // ✅ NEW: Optional minimum date

  /// ✅ This will now return the server-friendly YYYY-MM-DD format
  final void Function(String serverDate)? onChanged;

  @override
  State<AppDatePickerTextFormField> createState() =>
      _AppDatePickerTextFormFieldState();
}

class _AppDatePickerTextFormFieldState
    extends State<AppDatePickerTextFormField> {
  // ✅ UI Format (What the user sees)
  static const String uiFormat = 'dd-MM-yyyy';

  // ✅ Server Format (What the API needs)
  static const String serverFormat = 'yyyy-MM-dd';

  Future<void> _selectDate(BuildContext context) async {
    // ✅ Use minDate if provided, otherwise use DateTime(2000)
    final DateTime firstSelectableDate = widget.minDate ?? DateTime(2000);

    // Try to parse the current text in dd-mm-yyyy to set the initial date
    DateTime currentDate =
        _parseDate(widget.dateController.text) ?? DateTime.now();

    // ✅ If current date is before minDate, use minDate as initial date
    if (widget.minDate != null && currentDate.isBefore(widget.minDate!)) {
      currentDate = widget.minDate!;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstSelectableDate, // ✅ Set minimum selectable date
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        final bool tablet = AppScreenUtils.isTablet(context);

        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.kColorPrimary,
            colorScheme: const ColorScheme.light(
              primary: AppColors.kColorPrimary,
              secondary: AppColors.kColorSecondary,
              onPrimary: AppColors.kColorWhite,
              surface: AppColors.kColorWhite,
            ),
            textTheme: TextTheme(
              headlineMedium: TextStyles.kMediumDongle(
                fontSize: tablet
                    ? FontSizes.k32FontSize
                    : FontSizes.k24FontSize,
                color: AppColors.kColorWhite,
              ),
              bodyLarge: TextStyles.kRegularDongle(
                fontSize: tablet
                    ? FontSizes.k22FontSize
                    : FontSizes.k18FontSize,
                color: AppColors.kColorPrimary,
              ),
              bodyMedium: TextStyles.kMediumDongle(
                fontSize: tablet
                    ? FontSizes.k24FontSize
                    : FontSizes.k18FontSize,
                color: AppColors.kColorWhite,
              ),
              labelMedium: TextStyles.kMediumDongle(
                fontSize: tablet
                    ? FontSizes.k22FontSize
                    : FontSizes.k16FontSize,
                color: AppColors.kColorPrimary,
              ),
              labelLarge: TextStyles.kMediumDongle(
                fontSize: tablet
                    ? FontSizes.k24FontSize
                    : FontSizes.k18FontSize,
                color: AppColors.kColorPrimary,
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.kColorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tablet ? 20 : 12),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppColors.kColorWhite,
              headerBackgroundColor: AppColors.kColorPrimary,
              headerForegroundColor: AppColors.kColorWhite,
            ),
          ),
          child: Transform.scale(scale: tablet ? 1.3 : 1.0, child: child!),
        );
      },
    );

    if (pickedDate != null) {
      // 1. Format for UI (User sees this)
      final String formattedUIDate = DateFormat(uiFormat).format(pickedDate);

      // 2. Format for Server (API needs this)
      final String formattedServerDate = DateFormat(
        serverFormat,
      ).format(pickedDate);

      setState(() {
        widget.dateController.text = formattedUIDate;
      });

      if (widget.onChanged != null) {
        // ✅ Pass the server format (yyyy-mm-dd) back to the screen
        widget.onChanged!(formattedServerDate);
      }
    }
  }

  DateTime? _parseDate(String dateString) {
    if (dateString.isEmpty) return null;
    try {
      // Parse using dd-MM-yyyy because that's what's in the text field
      return DateFormat(uiFormat).parseStrict(dateString);
    } catch (e) {
      // Fallback for yyyy-MM-dd if the initial data is from the server
      try {
        return DateFormat(serverFormat).parseStrict(dateString);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextFormField(
      controller: widget.dateController,
      cursorColor: AppColors.kColorBlack,
      cursorHeight: tablet ? 26 : 20,
      enabled: widget.enabled,
      validator: widget.validator,
      style: TextStyles.kRegularDongle(
        fontSize: (tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize),
        color: AppColors.kColorBlack,
      ).copyWith(fontWeight: FontWeight.w400),
      readOnly: true,
      onTap: widget.enabled ? () => _selectDate(context) : null,
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
        floatingLabelBehavior: widget.floatingLabelRequired ?? true
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
        floatingLabelStyle: TextStyles.kMediumDongle(
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k18FontSize,
          color: AppColors.kColorBlack,
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
          borderColor: AppColors.kColorBlack,
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
        suffixIcon: Icon(
          Icons.calendar_today_rounded,
          size: tablet ? 25 : 20,
          color: AppColors.kColorBlack,
        ),
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
