import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_colors_dark.dart';

/// Extra colors that don't have a slot in Flutter's standard [ColorScheme]
/// (success/warning/info variants, borders, soft backgrounds, ...).
///
/// Colors that DO map to a standard ColorScheme role (primary, surface,
/// onSurface, error, ...) should keep using `Theme.of(context).colorScheme`
/// directly instead of being duplicated here.
///
/// Usage: `context.appColors.warning` (see context_extensions.dart)
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.border,
    required this.bgSubtle,
    required this.primarySoftBg,
    required this.success,
    required this.successBg,
    required this.warning,
    required this.warningBg,
    required this.dangerBg,
    required this.info,
    required this.infoBg,
    required this.primaryOnSoftBg,
    required this.onPrimarySoftBg,
  });

  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;

  final Color border;
  final Color bgSubtle;
  final Color primarySoftBg;

  final Color success;
  final Color successBg;
  final Color warning;
  final Color warningBg;

  /// Soft/background variant of danger. The danger color itself should
  /// come from `colorScheme.error`.
  final Color dangerBg;

  final Color info;
  final Color infoBg;

  /// Text/icon color used on top of [primarySoftBg] in badges such as
  /// GoalBadge (weightLoss / generalFitness):
  /// AppColors.primary in dark mode, AppColors.primaryDark in light mode.
  final Color primaryOnSoftBg;

  /// Button content color used on top of [primarySoftBg], e.g. AppErrorView's
  /// retry button: white in dark mode, AppColors.primaryDark in light mode.
  final Color onPrimarySoftBg;

  static const light = AppColorsExtension(
    textSecondary: AppColorsLight.textSecondary,
    textTertiary: AppColorsLight.textTertiary,
    textDisabled: AppColorsLight.textDisabled,
    border: AppColorsLight.border,
    bgSubtle: AppColorsLight.bgSubtle,
    primarySoftBg: AppColorsLight.primarySoftBg,
    success: AppColorsLight.success,
    successBg: AppColorsLight.successBg,
    warning: AppColorsLight.warning,
    warningBg: AppColorsLight.warningBg,
    dangerBg: AppColorsLight.dangerBg,
    info: AppColorsLight.info,
    infoBg: AppColorsLight.infoBg,
    primaryOnSoftBg: AppColors.primaryDark,
    onPrimarySoftBg: AppColors.primaryDark,
  );

  static const dark = AppColorsExtension(
    textSecondary: AppColorsDark.textSecondary,
    textTertiary: AppColorsDark.textTertiary,
    textDisabled: AppColorsDark.textDisabled,
    border: AppColorsDark.border,
    bgSubtle: AppColorsDark.bgSubtle,
    primarySoftBg: AppColorsDark.primarySoftBg,
    success: AppColorsDark.success,
    successBg: AppColorsDark.successBg,
    warning: AppColorsDark.warning,
    warningBg: AppColorsDark.warningBg,
    dangerBg: AppColorsDark.dangerBg,
    info: AppColorsDark.info,
    infoBg: AppColorsDark.infoBg,
    primaryOnSoftBg: AppColors.primary,
    onPrimarySoftBg: Colors.white,
  );

  @override
  AppColorsExtension copyWith({
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? border,
    Color? bgSubtle,
    Color? primarySoftBg,
    Color? success,
    Color? successBg,
    Color? warning,
    Color? warningBg,
    Color? dangerBg,
    Color? info,
    Color? infoBg,
    Color? primaryOnSoftBg,
    Color? onPrimarySoftBg,
  }) {
    return AppColorsExtension(
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      border: border ?? this.border,
      bgSubtle: bgSubtle ?? this.bgSubtle,
      primarySoftBg: primarySoftBg ?? this.primarySoftBg,
      success: success ?? this.success,
      successBg: successBg ?? this.successBg,
      warning: warning ?? this.warning,
      warningBg: warningBg ?? this.warningBg,
      dangerBg: dangerBg ?? this.dangerBg,
      info: info ?? this.info,
      infoBg: infoBg ?? this.infoBg,
      primaryOnSoftBg: primaryOnSoftBg ?? this.primaryOnSoftBg,
      onPrimarySoftBg: onPrimarySoftBg ?? this.onPrimarySoftBg,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      border: Color.lerp(border, other.border, t)!,
      bgSubtle: Color.lerp(bgSubtle, other.bgSubtle, t)!,
      primarySoftBg: Color.lerp(primarySoftBg, other.primarySoftBg, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      dangerBg: Color.lerp(dangerBg, other.dangerBg, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      primaryOnSoftBg: Color.lerp(primaryOnSoftBg, other.primaryOnSoftBg, t)!,
      onPrimarySoftBg: Color.lerp(onPrimarySoftBg, other.onPrimarySoftBg, t)!,
    );
  }
}