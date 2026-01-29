import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppPageIndicator extends StatefulWidget {
  final int currentStep;
  final int totalSteps;

  const AppPageIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  State<AppPageIndicator> createState() => _AppPageIndicatorState();
}

class _AppPageIndicatorState extends State<AppPageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.custom(bottom: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.totalSteps * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            return _buildModernStepCircle(stepIndex);
          } else {
            final lineIndex = index ~/ 2;
            return _buildModernConnectingLine(lineIndex);
          }
        }),
      ),
    );
  }

  Widget _buildModernStepCircle(int stepIndex) {
    final isCompleted = stepIndex < widget.currentStep;
    final isActive = stepIndex == widget.currentStep;
    final bool tablet = AppScreenUtils.isTablet(context);

    Widget circleContent;
    BoxDecoration decoration;

    if (isCompleted) {
      decoration = BoxDecoration(
        color: AppColors.kColorPrimary,
        borderRadius: BorderRadius.circular(tablet ? 20 : 10),
      );
      circleContent = const Icon(
        Icons.check,
        color: AppColors.kColorWhite,
        size: 20,
      );
    } else if (isActive) {
      decoration = BoxDecoration(
        color: AppColors.kColorPrimary,
        borderRadius: BorderRadius.circular(tablet ? 20 : 10),
      );
      circleContent = Text(
        '${stepIndex + 1}',
        style: TextStyles.kBoldDongle(
          fontSize: tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize,
          color: AppColors.kColorWhite,
        ),
      );
    } else {
      decoration = BoxDecoration(
        color: AppColors.kColorGrey,
        borderRadius: BorderRadius.circular(tablet ? 20 : 10),
      );
      circleContent = Text(
        '${stepIndex + 1}',
        style: TextStyles.kMediumDongle(
          fontSize: tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize,
          color: AppColors.kColorDarkGrey,
        ),
      );
    }

    Widget circle = Container(
      width: tablet ? 75 : 45,
      height: tablet ? 75 : 45,
      decoration: decoration,
      child: Center(child: circleContent),
    );

    return circle;
  }

  Widget _buildModernConnectingLine(int lineIndex) {
    final isCompleted = lineIndex < widget.currentStep;
    final isActive =
        lineIndex == widget.currentStep - 1 && widget.currentStep > 0;
    final bool tablet = AppScreenUtils.isTablet(context);

    return Container(
      width: tablet ? 60 : 40,
      height: tablet ? 8 : 4,
      decoration: BoxDecoration(
        color: isCompleted || isActive
            ? AppColors.kColorPrimary
            : AppColors.kColorGrey,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
