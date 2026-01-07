import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  // Dark Theme Background Gradients
  static const backgroundGradientStart = Color(0xff2D1B69); // Deep purple
  static const backgroundGradientEnd = Color(0xff1A1A2E); // Dark blue-black

  // Card and Surface Colors (with glassmorphism)
  static const cardBackground = Color(0x663D3458); // Semi-transparent purple
  static const cardBackgroundLight =
      Color(0x804A3F8F); // Lighter purple for overlays

  // Accent Colors
  static const accentPurple = Color(0xff8B7FD8); // Light purple accent
  static const accentPink =
      Color(0xffE91E63); // Pink accent for buttons/highlights
  static const accentOrange = Color(0xffFF9800); // Orange for important actions

  // Text Colors
  static const primaryTextColor = Color(0xffFFFFFF); // White
  static const secondaryTextColor = Color(0xffB0B0B0); // Gray for subtitles
  static const tertiaryTextColor = Color(0xff808080); // Darker gray for hints

  // Map and Route Colors
  static const routeColor = Color(0xffE91E63); // Pink for route lines
  static const markerColor = Color(0xffFF5252); // Red for markers
  static const geofenceColor =
      Color(0x4D8B7FD8); // Semi-transparent purple for geofence circle

  // Legacy colors (for backward compatibility during transition)
  static const primaryColor = backgroundGradientStart;
  static const primaryDarkColor = backgroundGradientEnd;
  static const primaryButtonColor = accentPink;
  static const linkColor = accentPurple;
}
