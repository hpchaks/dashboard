import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';
import 'package:dashboard/utils/screen_utils/app_spacings.dart';
import 'package:dashboard/widgets/app_button.dart';
import 'package:dashboard/widgets/app_text_button.dart';
import 'package:dashboard/widgets/app_text_form_field.dart';

class SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final List<String> selectedCodes;
  final List<String> selectedNames;
  final String Function(T) itemNameGetter;
  final String Function(T) itemCodeGetter;
  final TextEditingController searchController;
  final void Function(bool?, T) onSelectionChanged;
  final void Function() onSelectAll;
  final void Function() onClearAll;
  final double maxHeight;
  final void Function(String) onSearchChanged;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedCodes,
    required this.selectedNames,
    required this.itemNameGetter,
    required this.itemCodeGetter,
    required this.searchController,
    required this.onSelectionChanged,
    required this.onSelectAll,
    required this.onClearAll,
    required this.onSearchChanged,
    this.maxHeight = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);
    final mediaQuery = MediaQuery.of(context);
    final actualMaxHeight = mediaQuery.size.height * maxHeight;

    return Container(
      constraints: BoxConstraints(maxHeight: actualMaxHeight),
      padding: tablet
          ? AppPaddings.combined(horizontal: 24, vertical: 16)
          : AppPaddings.p16,
      decoration: BoxDecoration(
        color: AppColors.kColorWhite,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(tablet ? 20 : 10),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyles.kSemiBoldDongle(
                  fontSize: tablet
                      ? FontSizes.k26FontSize
                      : FontSizes.k20FontSize,
                ),
              ),
              Row(
                children: [
                  AppTextButton(onPressed: onSelectAll, title: 'Select All'),
                  AppSpaces.h10,
                  AppTextButton(onPressed: onClearAll, title: 'Clear All'),
                ],
              ),
            ],
          ),
          tablet ? AppSpaces.v16 : AppSpaces.v10,
          AppTextFormField(
            hintText: 'Search',
            controller: searchController,
            onChanged: onSearchChanged,
          ),
          tablet ? AppSpaces.v16 : AppSpaces.v10,
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Obx(
                    () => CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        itemNameGetter(item),
                        style: TextStyles.kRegularDongle(
                          fontSize: tablet
                              ? FontSizes.k22FontSize
                              : FontSizes.k16FontSize,
                          color: AppColors.kColorPrimary,
                        ),
                      ),
                      checkColor: AppColors.kColorWhite,
                      activeColor: AppColors.kColorPrimary,
                      value: selectedCodes.contains(itemCodeGetter(item)),
                      onChanged: (bool? selected) {
                        onSelectionChanged(selected, item);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          AppButton(
            onPressed: () {
              Get.back();
            },
            title: 'Done',
          ),
          tablet ? AppSpaces.v16 : AppSpaces.v10,
        ],
      ),
    );
  }
}
