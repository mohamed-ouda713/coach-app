import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// بيجمّع كل التوكنز (ألوان + خطوط) في ThemeData واحد جاهز
/// للاستخدام في MaterialApp(theme: AppTheme.light, darkTheme: AppTheme.dark).
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColorsLight.bgScreen,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColorsLight.bgCard,
        error: AppColorsLight.danger,
      ),
      cardColor: AppColorsLight.bgCard,
      dividerColor: AppColorsLight.border,
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1.copyWith(color: AppColorsLight.textPrimary),
        headlineMedium: AppTextStyles.h5.copyWith(color: AppColorsLight.textPrimary),
        bodyLarge: AppTextStyles.bodyL.copyWith(color: AppColorsLight.textPrimary),
        bodyMedium: AppTextStyles.bodyRegular.copyWith(color: AppColorsLight.textSecondary),
        bodySmall: AppTextStyles.caption.copyWith(color: AppColorsLight.textTertiary),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.bgScreen,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColorsDark.bgCard,
        error: AppColorsDark.danger,
      ),
      cardColor: AppColorsDark.bgCard,
      dividerColor: AppColorsDark.border,
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1.copyWith(color: AppColorsDark.textPrimary),
        headlineMedium: AppTextStyles.h5.copyWith(color: AppColorsDark.textPrimary),
        bodyLarge: AppTextStyles.bodyL.copyWith(color: AppColorsDark.textPrimary),
        bodyMedium: AppTextStyles.bodyRegular.copyWith(color: AppColorsDark.textSecondary),
        bodySmall: AppTextStyles.caption.copyWith(color: AppColorsDark.textTertiary),
      ),
    );
  }
}
