import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppTextButtonWithIcon extends StatelessWidget {
  const AppTextButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.title,
    required this.icon,
    this.color,
    this.fontSize,
    this.style,
  });

  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final double? fontSize;
  final TextStyle? style;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: AppPaddings.ph4,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(
        icon,
        size: tablet ? 25 : 20,
        color: color ?? AppColors.kColorPrimary,
      ),
      label: Text(
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
