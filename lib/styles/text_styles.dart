import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dashboard/constants/color_constants.dart';
import 'package:dashboard/styles/font_sizes.dart';

class TextStyles {
  static TextStyle kLightDongle({
    double fontSize = FontSizes.k20FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w300,
  }) {
    return GoogleFonts.dongle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle kRegularDongle({
    double fontSize = FontSizes.k20FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.dongle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle kItalicDongle({
    double fontSize = FontSizes.k20FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.dongle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle kMediumDongle({
    double fontSize = FontSizes.k20FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.dongle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle kSemiBoldDongle({
    double fontSize = FontSizes.k20FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.dongle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle kBoldDongle({
    double fontSize = FontSizes.k20FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.dongle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Outfit Font Styles
  static TextStyle kRegularOutfit({
    double fontSize = FontSizes.k14FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle kMediumOutfit({
    double fontSize = FontSizes.k14FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle kSemiBoldOutfit({
    double fontSize = FontSizes.k14FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle kBoldOutfit({
    double fontSize = FontSizes.k14FontSize,
    Color color = AppColors.kColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
