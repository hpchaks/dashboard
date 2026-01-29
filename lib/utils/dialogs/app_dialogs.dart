import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

void showErrorSnackbar(String title, String message) {
  final bool tablet = AppScreenUtils.isTablet(Get.context!);

  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.kColorRed,
    duration: const Duration(seconds: 3),
    margin: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    padding: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 750),
    titleText: Text(
      title,
      style: TextStyles.kMediumDongle(
        color: AppColors.kColorWhite,
        fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularDongle(
        fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
        color: AppColors.kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumDongle(
          color: AppColors.kColorWhite,
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
        ),
      ),
    ),
  );
}

void showSuccessSnackbar(String title, String message) {
  final bool tablet = AppScreenUtils.isTablet(Get.context!);

  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.kColorGreen,
    duration: const Duration(seconds: 3),
    margin: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    padding: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 750),
    titleText: Text(
      title,
      style: TextStyles.kMediumDongle(
        color: AppColors.kColorWhite,
        fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularDongle(
        fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
        color: AppColors.kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumDongle(
          color: AppColors.kColorWhite,
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
        ),
      ),
    ),
  );
}

// Info Snackbar
void showInfoSnackbar(String title, String message) {
  final bool tablet = AppScreenUtils.isTablet(Get.context!);

  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.kColorPrimary,
    duration: const Duration(seconds: 3),
    margin: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    padding: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 750),
    titleText: Text(
      title,
      style: TextStyles.kMediumDongle(
        color: AppColors.kColorWhite,
        fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularDongle(
        fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
        color: AppColors.kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumDongle(
          color: AppColors.kColorWhite,
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
        ),
      ),
    ),
  );
}

// Warning Snackbar (NEW!)
void showWarningSnackbar(String title, String message) {
  final bool tablet = AppScreenUtils.isTablet(Get.context!);

  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.kColorOrange,
    duration: const Duration(seconds: 3),
    margin: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    padding: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 750),
    titleText: Text(
      title,
      style: TextStyles.kMediumDongle(
        color: AppColors.kColorWhite,
        fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularDongle(
        fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
        color: AppColors.kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumDongle(
          color: AppColors.kColorWhite,
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
        ),
      ),
    ),
  );
}

// Gradient Snackbar (Extra Stylish!)
void showGradientSnackbar(
  String title,
  String message, {
  bool isError = false,
}) {
  final bool tablet = AppScreenUtils.isTablet(Get.context!);

  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isError ? AppColors.kColorRed : AppColors.kColorPrimary,
    duration: const Duration(seconds: 3),
    margin: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    padding: tablet
        ? AppPaddings.combined(horizontal: 20, vertical: 15)
        : AppPaddings.p10,
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 750),
    boxShadows: [
      BoxShadow(
        color: isError
            ? AppColors.kColorRed.withValues(alpha: 0.4)
            : AppColors.kColorPrimary.withValues(alpha: 0.4),
        blurRadius: 20,
        offset: const Offset(0, 10),
        spreadRadius: 2,
      ),
    ],
    titleText: Text(
      title,
      style: TextStyles.kMediumDongle(
        color: AppColors.kColorWhite,
        fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kRegularDongle(
        fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
        color: AppColors.kColorWhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kMediumDongle(
          color: AppColors.kColorWhite,
          fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k20FontSize,
        ),
      ),
    ),
  );
}
