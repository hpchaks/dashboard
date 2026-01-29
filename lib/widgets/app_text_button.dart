import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.color,
    this.fontSize,
    this.style,
  });

  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final double? fontSize;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(
        title,
        style:
            style ??
            TextStyles.kMediumDongle(
              color: color ?? AppColors.kColorPrimary,
              fontSize:
                  fontSize ??
                  (tablet ? FontSizes.k24FontSize : FontSizes.k18FontSize),
            ).copyWith(
              height: 1,
              decoration: TextDecoration.underline,
              decorationColor: color ?? AppColors.kColorPrimary,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
