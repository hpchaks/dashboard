import 'package:flutter/material.dart';

class AppColors {
  // Base Palette (Private)
  static const Color _blue = Color(0xFF5DC6FF);
  static const Color _orange = Color(0xFFFFAE5D);
  static const Color _red = Color(0xFFFF0000);
  static const Color _green = Color(0xFF5DFFA3);
  static const Color _pink = Color(0xFFFF5DDF);
  static const Color _purple = Color(0xFF625DFF);
  static const Color _black = Colors.black87;

  // Key Application Colors
  static const Color kColorWhite = Colors.white;
  static const Color kColorPrimary = Color(
    0xFF042D65,
  ); // Replaces customDarkBlue
  static const Color kColorSecondary = Color(0xFFE91E63); // Replaces customRed
  static const Color kColorGrey = Color(0xFF9E9E9E); // Custom Grey
  static const Color kColorRed = Color(0xFFE31E24);
  static const Color kColorGreen = Color(0xFF43A047);
  static const Color kColorBlack = Colors.black;
  static const Color kColorDarkGrey = Color(0xFF616161);
  static const Color kColorTextPrimary = Colors.black87;
  static const Color kColorBlackWithOpacity = Colors.black54;
  static const Color kColorOrange = Colors.orange;

  // ==========================================
  // 1. Total Orders Card Colors
  // ==========================================
  static const Color totalPending = Color(0xFF1565C0); // Dark Blue
  static const Color totalDue = Color(0xFFC62828); // Dark Red
  static const Color totalNotDue = Color(0xFF8E7E30); // Dark Green
  static const Color totalText = _black;

  // ==========================================
  // 2. Planned Order Card Colors
  // ==========================================
  static const Color plannedInProduction = Color(0xFFE65100); // Dark Orange
  static const Color plannedDelivered = Color(0xFF26842C); // Dark Green
  static const Color plannedHold = Color(0xFFA81B66); // Dark Pink/Maroon
  static const Color plannedText = _black;

  // ==========================================
  // 3. Production Timeline Colors (Base colors)
  // ==========================================
  static const Color timelinePlanned = _blue;
  static const Color timelinePending = _blue;
  static const Color timelineInProduction = _orange;
  static const Color timelineDue = _red;
  static const Color timelineDelivered = _green;
  static const Color timelineNotDue = _blue;
  static const Color timelineHold = _pink;
  static const Color timelineDeliveryDue = _red;
  static const Color timelineAchievable = _blue;
  static const Color timelineNotAchievable = _pink;
  static const Color timelineCapacity = _purple;
  static const Color timelineText = _black;
}
