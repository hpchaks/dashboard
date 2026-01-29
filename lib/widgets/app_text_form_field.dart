import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/extensions/app_size_extensions.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    this.focusNode,
    this.floatingLabelRequired,
    this.enabled,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.validator,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.fillColor,
    this.suffixIcon,
    this.isObscure = false,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onSubmitted,
    this.onTap,
    this.fontSize,
    this.fontWeight,
    this.readOnly = false, // ✅ Fixed: Defined properly with default value
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool? floatingLabelRequired;
  final bool? enabled;
  final int? maxLines;
  final int? minLines;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final Widget? suffixIcon;
  final bool? isObscure;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool readOnly; // ✅ Fixed: Added Field

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      cursorColor: AppColors.kColorBlack,
      cursorHeight: tablet ? 26 : 20,
      inputFormatters: inputFormatters,
      enabled: enabled ?? true,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      readOnly: readOnly, // ✅ Fixed: Passed to Widget
      textInputAction: textInputAction ?? TextInputAction.done,
      keyboardType: keyboardType ?? TextInputType.text,
      style: TextStyles.kRegularDongle(
        fontSize:
            fontSize ??
            (tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize),
        color: AppColors.kColorBlack,
      ).copyWith(fontWeight: fontWeight ?? FontWeight.w400),
      obscureText: isObscure!,
      onEditingComplete: () {
        if (onSubmitted != null) {
          onSubmitted!(controller.text);
        }
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyles.kRegularDongle(
          fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
          color: AppColors.kColorDarkGrey,
        ),
        labelText: hintText,
        labelStyle: TextStyles.kRegularDongle(
          fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
          color: AppColors.kColorDarkGrey,
        ),
        floatingLabelBehavior: (floatingLabelRequired ?? true)
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
        fillColor: fillColor ?? AppColors.kColorWhite,
        suffixIcon: suffixIcon,
        // Removed hardcoded suffixIconColor so custom icon colors (Primary) work
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
