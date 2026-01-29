import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    this.floatingLabelRequired,
    this.selectedItem,
    this.hintText, // Changed: Now optional (nullable)
    this.searchHintText,
    this.fillColor,
    this.showSearchBox,
    required this.onChanged,
    this.validatorText,
    this.enabled,
    this.clearButtonProps,
    this.borderRadius,
    this.hideBorder = false,
  });

  final List<String> items;
  final bool? floatingLabelRequired;
  final String? selectedItem;
  final String? hintText; // Changed to String?
  final String? searchHintText;
  final Color? fillColor;
  final bool? showSearchBox;
  final ValueChanged<String?>? onChanged;
  final String? validatorText;
  final bool? enabled;
  final ClearButtonProps? clearButtonProps;
  final bool? borderRadius;
  final bool hideBorder;

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return DropdownSearch<String>(
      selectedItem: selectedItem,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
      items: (filter, infiniteScrollProps) => items,
      enabled: enabled ?? true,
      suffixProps: DropdownSuffixProps(
        clearButtonProps:
            clearButtonProps ?? const ClearButtonProps(isVisible: false),
      ),
      decoratorProps: DropDownDecoratorProps(
        baseStyle: TextStyles.kRegularDongle(
          fontSize: (tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize),
          color: AppColors.kColorBlack,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyles.kRegularDongle(
            fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
            color: AppColors.kColorDarkGrey,
          ),
          labelText: hintText, // If hintText is null, label won't show
          labelStyle: TextStyles.kRegularDongle(
            fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
            color: AppColors.kColorDarkGrey,
          ),
          floatingLabelBehavior: floatingLabelRequired ?? true
              ? FloatingLabelBehavior.auto
              : FloatingLabelBehavior.never,
          floatingLabelStyle: TextStyles.kMediumDongle(
            fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k18FontSize,
            color: AppColors.kColorBlack,
          ),
          errorStyle: TextStyles.kRegularDongle(
            fontSize: tablet ? FontSizes.k18FontSize : FontSizes.k14FontSize,
            color: AppColors.kColorRed,
          ),

          border: hideBorder
              ? InputBorder.none
              : outlineInputBorder(
                  borderColor: AppColors.kColorDarkGrey,
                  borderWidth: 1,
                  tablet: tablet,
                ),
          enabledBorder: hideBorder
              ? InputBorder.none
              : outlineInputBorder(
                  borderColor: AppColors.kColorDarkGrey,
                  borderWidth: 1,
                  tablet: tablet,
                ),
          disabledBorder: hideBorder
              ? InputBorder.none
              : outlineInputBorder(
                  borderColor: AppColors.kColorDarkGrey,
                  borderWidth: 1,
                  tablet: tablet,
                ),
          focusedBorder: hideBorder
              ? InputBorder.none
              : outlineInputBorder(
                  borderColor: AppColors.kColorBlack,
                  borderWidth: 1,
                  tablet: tablet,
                ),
          errorBorder: hideBorder
              ? InputBorder.none
              : outlineInputBorder(
                  borderColor: AppColors.kColorRed,
                  borderWidth: 1,
                  tablet: tablet,
                ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          filled: true,
          fillColor: fillColor ?? AppColors.kColorWhite,
          suffixIconColor: AppColors.kColorBlack,
        ),
      ),
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        constraints: BoxConstraints(maxHeight: tablet ? 450 : 300),
        menuProps: MenuProps(
          backgroundColor: AppColors.kColorWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        itemBuilder: (context, item, isDisabled, isSelected) => Padding(
          padding: AppPaddings.p10,
          child: Text(
            item,
            style: TextStyles.kRegularDongle(
              color: AppColors.kColorBlack,
              fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
            ).copyWith(height: 1),
          ),
        ),
        showSearchBox: showSearchBox ?? true,
        searchFieldProps: TextFieldProps(
          style: TextStyles.kRegularDongle(
            fontSize: (tablet ? FontSizes.k22FontSize : FontSizes.k16FontSize),
            color: AppColors.kColorBlack,
          ),
          cursorColor: AppColors.kColorBlack,
          cursorHeight: tablet ? 26 : 20,
          decoration: InputDecoration(
            hintText: searchHintText ?? 'Search',
            hintStyle: TextStyles.kRegularDongle(
              fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
              color: AppColors.kColorDarkGrey,
            ),
            labelText: hintText,
            labelStyle: TextStyles.kRegularDongle(
              fontSize: tablet ? FontSizes.k20FontSize : FontSizes.k16FontSize,
              color: AppColors.kColorDarkGrey,
            ),
            floatingLabelBehavior: floatingLabelRequired ?? true
                ? FloatingLabelBehavior.auto
                : FloatingLabelBehavior.never,
            floatingLabelStyle: TextStyles.kMediumDongle(
              fontSize: tablet ? FontSizes.k24FontSize : FontSizes.k18FontSize,
              color: AppColors.kColorBlack,
            ),
            errorStyle: TextStyles.kRegularDongle(
              fontSize: tablet ? FontSizes.k18FontSize : FontSizes.k14FontSize,
              color: AppColors.kColorRed,
            ),
            border: outlineInputBorder(
              borderColor: AppColors.kColorDarkGrey,
              borderWidth: 1,
              tablet: tablet,
            ),
            enabledBorder: outlineInputBorder(
              borderColor: AppColors.kColorDarkGrey,
              borderWidth: 1,
              tablet: tablet,
            ),
            disabledBorder: outlineInputBorder(
              borderColor: AppColors.kColorDarkGrey,
              borderWidth: 1,
              tablet: tablet,
            ),
            focusedBorder: outlineInputBorder(
              borderColor: AppColors.kColorBlack,
              borderWidth: 1,
              tablet: tablet,
            ),
            errorBorder: outlineInputBorder(
              borderColor: AppColors.kColorRed,
              borderWidth: 1,
              tablet: tablet,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: fillColor ?? AppColors.kColorWhite,
            suffixIconColor: AppColors.kColorBlack,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color borderColor,
    required double borderWidth,
    required bool tablet,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}
