import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/extensions/app_size_extensions.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppMultipleSelectionField extends StatelessWidget {
  final String placeholder;
  final List<String> selectedItems;
  final VoidCallback onTap;
  final bool showFullList;
  final int maxItemsToShow;

  const AppMultipleSelectionField({
    super.key,
    required this.placeholder,
    required this.selectedItems,
    required this.onTap,
    this.showFullList = false,
    this.maxItemsToShow = 1,
  });

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.kColorWhite,
          borderRadius: BorderRadius.circular(tablet ? 20 : 10),
          border: Border.all(color: AppColors.kColorDarkGrey),
        ),
        child: Obx(() {
          final isEmpty = selectedItems.isEmpty;
          final text = isEmpty
              ? placeholder
              : showFullList
              ? selectedItems.join(', ')
              : selectedItems.length <= maxItemsToShow
              ? selectedItems.join(', ')
              : '${selectedItems.take(maxItemsToShow).join(', ')}, ...';

          return Padding(
            padding: tablet
                ? AppPaddings.combined(horizontal: 20, vertical: 12)
                : AppPaddings.combined(
                    horizontal: 16.appWidth,
                    vertical: 8.appHeight,
                  ),
            child: Text(
              text,
              style: isEmpty
                  ? TextStyles.kRegularDongle(
                      fontSize: tablet
                          ? FontSizes.k20FontSize
                          : FontSizes.k16FontSize,
                      color: AppColors.kColorDarkGrey,
                    )
                  : TextStyles.kMediumDongle(
                      fontSize: tablet
                          ? FontSizes.k22FontSize
                          : FontSizes.k18FontSize,
                      color: AppColors.kColorPrimary,
                    ).copyWith(fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }),
      ),
    );
  }
}
