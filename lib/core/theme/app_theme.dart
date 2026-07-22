import 'package:flutter/material.dart';
import '../constants/app_borders.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import 'app_colors.dart';
import 'app_colors_extension.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
    brightness: Brightness.light,
    bgScreen: AppColorsLight.bgScreen,
    bgCard: AppColorsLight.bgCard,
    bgSubtle: AppColorsLight.bgSubtle,
    border: AppColorsLight.border,
    textPrimary: AppColorsLight.textPrimary,
    textSecondary: AppColorsLight.textSecondary,
    danger: AppColorsLight.danger,
    extension: AppColorsExtension.light,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    bgScreen: AppColorsDark.bgScreen,
    bgCard: AppColorsDark.bgCard,
    bgSubtle: AppColorsDark.bgSubtle,
    border: AppColorsDark.border,
    textPrimary: AppColorsDark.textPrimary,
    textSecondary: AppColorsDark.textSecondary,
    danger: AppColorsDark.danger,
    extension: AppColorsExtension.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color bgScreen,
    required Color bgCard,
    required Color bgSubtle,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color danger,
    required AppColorsExtension extension,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bgScreen,
      primaryColor: AppColors.primary,
      cardColor: bgCard,
      dividerColor: border,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        error: danger,
        onError: Colors.white,
        surface: bgCard,
        onSurface: textPrimary,
      ),
      // Custom colors that don't have a standard ColorScheme role
      // (success/warning/info, borders, soft backgrounds, ...).
      // Access via `context.appColors` (see extensions/context_extensions.dart).
      extensions: [extension],
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayXL.copyWith(color: textPrimary),
        headlineLarge: AppTextStyles.h1.copyWith(color: textPrimary),
        headlineMedium: AppTextStyles.h2.copyWith(color: textPrimary),
        bodyLarge: AppTextStyles.bodyL.copyWith(color: textPrimary),
        bodyMedium: AppTextStyles.bodyM.copyWith(color: textSecondary),
        labelLarge: AppTextStyles.buttonM.copyWith(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.cardLg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          borderSide: BorderSide(color: border, width: AppBorders.regular),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppBorders.regular,
          ),
        ),
      ),
    );
  }
}