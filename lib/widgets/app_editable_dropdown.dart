import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/utils/extensions/app_size_extensions.dart';
import 'package:dashboard/utils/screen_utils/app_paddings.dart';
import 'package:dashboard/utils/screen_utils/app_screen_utils.dart';
import 'package:dashboard/styles/font_sizes.dart';
import 'package:dashboard/styles/text_styles.dart';

class EditableDropdownTextField extends StatefulWidget {
  final String value;
  final String hintText;
  final List<String> options;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool? enabled;

  const EditableDropdownTextField({
    super.key,
    required this.value,
    required this.hintText,
    required this.options,
    this.onFieldSubmitted,
    this.validator,
    this.fillColor,
    this.suffixIcon,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    this.keyboardType,
    this.enabled,
  });

  @override
  State<EditableDropdownTextField> createState() =>
      _EditableDropdownTextFieldState();
}

class _EditableDropdownTextFieldState extends State<EditableDropdownTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant EditableDropdownTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.value;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = AppScreenUtils.isTablet(context);

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return widget.options;
      },
      onSelected: (String selection) {
        _controller.text = selection;
        widget.onFieldSubmitted?.call(selection);
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_controller.text != textEditingController.text) {
                textEditingController.text = _controller.text;
              }
            });

            textEditingController.addListener(() {
              if (_controller.text != textEditingController.text) {
                _controller.text = textEditingController.text;
              }
            });

            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              validator: widget.validator,
              enabled: widget.enabled ?? true,
              inputFormatters: widget.inputFormatters,
              maxLines: widget.maxLines ?? 1,
              minLines: widget.minLines ?? 1,
              onFieldSubmitted: widget.onFieldSubmitted,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              cursorColor: AppColors.kColorBlack,
              cursorHeight: tablet ? 26 : 20,
              style: TextStyles.kRegularDongle(
                fontSize: (tablet
                    ? FontSizes.k22FontSize
                    : FontSizes.k16FontSize),
                color: AppColors.kColorBlack,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyles.kRegularDongle(
                  fontSize: tablet
                      ? FontSizes.k20FontSize
                      : FontSizes.k16FontSize,
                  color: AppColors.kColorDarkGrey,
                ),
                labelText: widget.hintText,
                labelStyle: TextStyles.kRegularDongle(
                  fontSize: tablet
                      ? FontSizes.k20FontSize
                      : FontSizes.k16FontSize,
                  color: AppColors.kColorDarkGrey,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: TextStyles.kMediumDongle(
                  fontSize: tablet
                      ? FontSizes.k24FontSize
                      : FontSizes.k18FontSize,
                  color: AppColors.kColorBlack,
                ),
                errorStyle: TextStyles.kRegularDongle(
                  fontSize: tablet
                      ? FontSizes.k18FontSize
                      : FontSizes.k14FontSize,
                  color: AppColors.kColorRed,
                ),
                suffixIcon:
                    widget.suffixIcon ??
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.kColorBlack,
                      size: tablet ? 28 : 24,
                    ),
                filled: true,
                fillColor: widget.fillColor ?? AppColors.kColorWhite,
                contentPadding: tablet
                    ? AppPaddings.combined(horizontal: 20, vertical: 12)
                    : AppPaddings.combined(
                        horizontal: 16.appWidth,
                        vertical: 8.appHeight,
                      ),
                border: outlineInputBorder(
                  borderColor: AppColors.kColorDarkGrey,
                  borderWidth: 1,
                  tablet: tablet,
                ),
                focusedBorder: outlineInputBorder(
                  borderColor: AppColors.kColorBlack,
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
                errorBorder: outlineInputBorder(
                  borderColor: AppColors.kColorRed,
                  borderWidth: 1,
                  tablet: tablet,
                ),
                suffixIconColor: AppColors.kColorBlack,
              ),
            );
          },
      optionsViewBuilder: (context, onSelected, options) {
        final bool tablet = AppScreenUtils.isTablet(context);

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(tablet ? 16 : 10),
            child: Container(
              constraints: BoxConstraints(maxHeight: tablet ? 400 : 250),
              decoration: BoxDecoration(
                color: AppColors.kColorWhite,
                borderRadius: BorderRadius.circular(tablet ? 16 : 10),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: tablet
                          ? AppPaddings.combined(horizontal: 20, vertical: 14)
                          : AppPaddings.p12,
                      child: Text(
                        option,
                        style: TextStyles.kRegularDongle(
                          fontSize: tablet
                              ? FontSizes.k20FontSize
                              : FontSizes.k16FontSize,
                          color: AppColors.kColorBlack,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color borderColor,
    required double borderWidth,
    required bool tablet,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(tablet ? 20 : 10),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}
