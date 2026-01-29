import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/extensions/app_size_extensions.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppTimePickerField extends StatefulWidget {
  const AppTimePickerField({
    super.key,
    required this.timeController,
    required this.hintText,
    this.fillColor,
    this.enabled = true,
    this.validator,
  });

  final TextEditingController timeController;
  final String hintText;
  final Color? fillColor;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  State<AppTimePickerField> createState() => _AppTimePickerFieldState();
}

class _AppTimePickerFieldState extends State<AppTimePickerField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay currentTime =
        _parseTime(widget.timeController.text) ?? TimeOfDay.now();

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(data: _buildTimePickerTheme(context), child: child!);
      },
    );

    if (pickedTime != null) {
      _focusNode.unfocus();
      final now = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(
        DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        ),
      );
      setState(() {
        widget.timeController.text = formattedTime;
      });
    }
  }

  TimeOfDay? _parseTime(String timeString) {
    try {
      final format = DateFormat.jm();
      final DateTime dateTime = format.parse(timeString);
      return TimeOfDay.fromDateTime(dateTime);
    } catch (e) {
      return null;
    }
  }

  ThemeData _buildTimePickerTheme(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return ThemeData.light().copyWith(
      primaryColor: AppColors.kColorPrimary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.kColorPrimary,
        onPrimary: AppColors.kColorWhite,
        surface: AppColors.kColorWhite,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyles.kMediumDongle(
          fontSize: tablet ? FontSizes.k32FontSize : FontSizes.k24FontSize,
          color: AppColors.kColorBlack,
        ),
        bodyLarge: TextStyles.kRegularDongle(
          fontSize: tablet ? FontSizes.k22FontSize : FontSizes.k18FontSize,
          color: AppColors.kColorBlack,
        ),
        bodyMedium: TextStyles.kMediumDongle(
          fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
          color: AppColors.kColorBlack,
        ),
        labelLarge: TextStyles.kMediumDongle(
          fontSize: tablet ? FontSizes.k22FontSize : FontSizes.k18FontSize,
          color: AppColors.kColorPrimary,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.kColorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tablet ? 20 : 12),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.kColorWhite,
        hourMinuteTextColor: AppColors.kColorBlack,
        dialHandColor: AppColors.kColorPrimary,
        dialBackgroundColor: AppColors.kColorWhite,
        entryModeIconColor: AppColors.kColorPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextFormField(
      controller: widget.timeController,
      focusNode: _focusNode,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      enabled: widget.enabled,
      cursorColor: AppColors.kColorBlack,
      cursorHeight: tablet ? 26 : 20,
      style: TextStyles.kRegularDongle(
        fontSize: (tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize),
        color: AppColors.kColorBlack,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor ?? AppColors.kColorWhite,
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
        focusedBorder: outlineInputBorder(
          borderColor: AppColors.kColorBlack,
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
        suffixIcon: IconButton(
          icon: Icon(
            Icons.access_time_filled,
            size: tablet ? 25 : 20,
            color: AppColors.kColorBlack,
          ),
          onPressed: widget.enabled ? () => _selectTime(context) : null,
        ),
        suffixIconColor: AppColors.kColorBlack,
      ),
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter or select a time';
            }
            return null;
          },
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
