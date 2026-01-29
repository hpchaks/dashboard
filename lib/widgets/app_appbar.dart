import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppbar({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.leading,
    this.automaticallyImplyLeading,
    this.actions,
    this.bgColor,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? leading;
  final bool? automaticallyImplyLeading;
  final List<Widget>? actions;
  final Color? bgColor;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    final hasLeading = (leading != null) || (automaticallyImplyLeading == true);

    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      backgroundColor: bgColor ?? AppColors.kColorWhite,
      centerTitle: false,
      elevation: 0,
      toolbarHeight: tablet ? 100.0 : kToolbarHeight,
      titleSpacing: hasLeading ? 0 : (tablet ? 24.0 : 16.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style:
                titleStyle ??
                TextStyles.kMediumDongle(
                  fontSize: tablet
                      ? FontSizes.k26FontSize
                      : FontSizes.k20FontSize,
                  color: AppColors.kColorPrimary,
                ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style:
                  subtitleStyle ??
                  TextStyles.kRegularDongle(
                    fontSize: tablet
                        ? FontSizes.k20FontSize
                        : FontSizes.k16FontSize,
                    color: AppColors.kColorPrimary,
                  ),
            ),
        ],
      ),
      leading: leading,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    final bool tablet = AppScreenUtils.isTablet(Get.context!);
    final double toolbarHeight = tablet ? 100.0 : kToolbarHeight;
    final double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(toolbarHeight + bottomHeight);
  }
}
