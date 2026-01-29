import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonColor,
    this.borderColor,
    required this.title,
    this.titleSize,
    this.titleColor,
    required this.onPressed,
    this.isLoading = false,
    this.loadingIndicatorColor,
  });

  final double? buttonHeight;
  final double? buttonWidth;
  final Color? buttonColor;
  final String title;
  final double? titleSize;
  final Color? titleColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? loadingIndicatorColor;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return SizedBox(
      height: buttonHeight ?? (tablet ? 65 : 45),
      width: buttonWidth ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: AppPaddings.p2,
          backgroundColor: buttonColor ?? AppColors.kColorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tablet ? 20 : 10),
            side: BorderSide(
              color: borderColor ?? (buttonColor ?? AppColors.kColorPrimary),
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: tablet ? 28 : 20,
                width: tablet ? 28 : 20,
                child: CircularProgressIndicator(
                  color: loadingIndicatorColor ?? AppColors.kColorWhite,
                  strokeWidth: 2,
                ),
              )
            : Text(
                title,
                style: TextStyles.kMediumDongle(
                  fontSize:
                      titleSize ??
                      (tablet ? FontSizes.k24FontSize : FontSizes.k18FontSize),
                  color: titleColor ?? AppColors.kColorWhite,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
