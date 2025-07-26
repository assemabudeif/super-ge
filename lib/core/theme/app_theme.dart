import 'package:flutter/material.dart';
import 'package:super_ge/core/theme/app_colors.dart';

/// A singleton class that defines the application's theme.
///
/// This class provides a centralized definition for the app's light theme,
/// including color scheme, typography, and widget-specific themes like
/// `AppBar`, `InputDecoration`, and `ElevatedButton`.
class AppTheme {
  // The single instance of the AppTheme class.
  static final AppTheme instance = AppTheme._internal();

  // Private constructor for the singleton pattern.
  AppTheme._internal();

  factory AppTheme() => instance;

  /// The default font family for the application.
  final String fontFamily = 'Cairo';

  /// The light theme data for the application.
  final ThemeData lightTheme = ThemeData(
    fontFamily: "Cairo",
    primarySwatch: AppColors.primarySwatch,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor, // Changed for better contrast
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo', // Ensure font family is consistent
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.white), // Set icon color
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.gray,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.gray,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        fixedSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Cairo', // Ensure font family is consistent
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
    dividerColor: AppColors.dividerColor,
    dividerTheme: DividerThemeData(
      color: AppColors.dividerColor,
      thickness: 1,
    ),
  );
}
