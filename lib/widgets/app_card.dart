import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.elevation,
  });

  final Color? color;
  final Color? borderColor;
  final double? borderRadius;
  final Widget child;
  final VoidCallback? onTap;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: elevation ?? 5,
        margin: AppPaddings.custom(bottom: tablet ? 16 : 10),
        color: color ?? AppColors.kColorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? (tablet ? 20 : 10),
          ),
          side: BorderSide(color: borderColor ?? AppColors.kColorGrey),
        ),
        child: Padding(
          padding: tablet
              ? AppPaddings.combined(horizontal: 20, vertical: 15)
              : AppPaddings.p12,
          child: child,
        ),
      ),
    );
  }
}
