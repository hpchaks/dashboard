import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';
import 'package:lottie/lottie.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const AppLoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.kColorBlackWithOpacity,
      child: const Center(child: AppProgressIndicator()),
    );
  }
}

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);
    return SizedBox(
      width: size ?? (tablet ? 155 : 125),
      height: size ?? (tablet ? 155 : 125),
      child: Center(
        child: Lottie.asset(
          'assets/dashboard_manager.json',
          width: size,
          height: size,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
