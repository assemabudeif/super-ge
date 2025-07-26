import 'package:flutter/material.dart';

/// A class that holds the color palette for the application.
///
/// This class defines the primary, secondary, and other common colors
/// used throughout the app's UI, ensuring a consistent look and feel.
class AppColors {
  /// The primary color of the application.
  static const primaryColor = Color(0xFF2564AF);

  /// The secondary color of the application.
  static const secondaryColor = Color(0xFF2564AF);

  /// A light variant of the primary color.
  static const primaryColorLight = Color(0xffe1f5fe);

  /// A dark variant of the primary color.
  static const primaryColorDark = Color(0xFF004D8C);

  /// The material color swatch for the primary color.
  static const primarySwatch = MaterialColor(0xFF2564AF, {
    50: Color(0xFFE1F5FE),
    100: Color(0xFFB3E5FC),
    200: Color(0xFF81D4FA),
    300: Color(0xFF4FC3F7),
    400: Color(0xFF29B6F6),
    500: Color(0xFF03A9F4),
    600: Color(0xFF0288D1),
    700: Color(0xFF0277BD),
    800: Color(0xFF01579B),
    900: Color(0xFF004D8C),
  });

  /// The color white.
  static const white = Colors.white;

  /// The color black.
  static const black = Colors.black;

  /// The color grey.
  static const gray = Colors.grey;

  /// The default background color for scaffolds.
  static const scaffoldBackground = Color(0xFFF5F5F5);

  /// The color used for dividers.
  static final dividerColor = Colors.grey[300];
}
