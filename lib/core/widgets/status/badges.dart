import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart'; // تأكد من صحة المسار لمشروعك
import '../../constants/app_enums.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// حاوية بصرية موحدة لكل "الشارات الصغيرة الملوّنة" بالتطبيق —
/// نفس البنية بالضبط (padding + radius + نص)، بس بألوان مختلفة حسب الحالة.
class _Badge extends StatelessWidget {
  const _Badge({
    required this.label, 
    required this.background, 
    required this.foreground,
    this.textStyle, // إمكانية تمرير ستايل مخصص للشارات الاستثنائية
  });

  final String label;
  final Color background;
  final Color foreground;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      // تنظيف: استبدال الأرقام الثابتة بالاعتماد على قيم الـ Spacing لتناسق الشاشات
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md, // تم تغيير الـ 9 و 10 الثابتة إلى الـ System Spacing
        vertical: AppSpacing.xs / 2, 
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        label,
        style: textStyle ?? AppTextStyles.tiny.copyWith(
          color: foreground, 
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// شارة صغيرة ملوّنة توضح حالة اشتراك المشتركة (نشط / ينتهي قريباً / منتهي).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (Color bg, Color fg, String label) = switch (status) {
      SubscriptionStatus.active => (
          isDark ? AppColorsDark.successBg : AppColorsLight.successBg,
          isDark ? AppColorsDark.success : AppColorsLight.success,
          AppStrings.statusActive,
        ),
      SubscriptionStatus.expiringSoon => (
          isDark ? AppColorsDark.warningBg : AppColorsLight.warningBg,
          isDark ? AppColorsDark.warning : AppColorsLight.warning,
          AppStrings.statusExpiringSoon,
        ),
      SubscriptionStatus.expired => (
          isDark ? AppColorsDark.dangerBg : AppColorsLight.dangerBg,
          isDark ? AppColorsDark.danger : AppColorsLight.danger,
          AppStrings.statusExpired,
        ),
    };

    return _Badge(label: label, background: bg, foreground: fg);
  }
}

/// شارة صغيرة ملوّنة توضح برنامج المشتركة (جيم / منزل).
class ProgramBadge extends StatelessWidget {
  const ProgramBadge({super.key, required this.program});

  final ProgramType program;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (Color bg, Color fg, String label) = switch (program) {
      ProgramType.gym => (
          isDark ? AppColorsDark.infoBg : AppColorsLight.infoBg,
          isDark ? AppColorsDark.info : AppColorsLight.info,
          AppStrings.programGym,
        ),
      ProgramType.home => (
          isDark ? AppColorsDark.infoBg : AppColorsLight.infoBg,
          isDark ? AppColorsDark.info : AppColorsLight.info,
          AppStrings.programHome,
        ),
    };

    return _Badge(label: label, background: bg, foreground: fg);
  }
}

/// شارة صغيرة ملوّنة توضح هدف المشتركة (خسارة وزن / زيادة كتلة / لياقة عامة / تعافي).
class GoalBadge extends StatelessWidget {
  const GoalBadge({super.key, required this.goal});

  final FitnessGoal goal;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (Color bg, Color fg, String label) = switch (goal) {
      FitnessGoal.weightLoss => (
          isDark ? AppColorsDark.primarySoftBg : AppColorsLight.primarySoftBg,
          isDark ? AppColors.primary : AppColors.primaryDark,
          AppStrings.goalWeightLoss,
        ),
      FitnessGoal.generalFitness => (
          isDark ? AppColorsDark.primarySoftBg : AppColorsLight.primarySoftBg,
          isDark ? AppColors.primary : AppColors.primaryDark,
          AppStrings.goalGeneralFitness,
        ),
      FitnessGoal.muscleGain => (
          isDark ? AppColorsDark.infoBg : AppColorsLight.infoBg,
          isDark ? AppColorsDark.info : AppColorsLight.info,
          AppStrings.goalMuscleGain,
        ),
      FitnessGoal.recovery => (
          isDark ? AppColorsDark.warningBg : AppColorsLight.warningBg,
          isDark ? AppColorsDark.warning : AppColorsLight.warning,
          AppStrings.goalRecovery,
        ),
    };

    return _Badge(label: label, background: bg, foreground: fg);
  }
}

/// شارة صغيرة توضح مقدار التغيّر بقياس معيّن (وزن/خصر/بطن) بين شهرين.
class MeasurementDeltaBadge extends StatelessWidget {
  const MeasurementDeltaBadge({super.key, required this.value, required this.unit});

  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isImprovement = value <= 0;

    final Color bg = isImprovement
        ? (isDark ? AppColorsDark.successBg : AppColorsLight.successBg)
        : (isDark ? AppColorsDark.dangerBg : AppColorsLight.dangerBg);
    final Color fg = isImprovement
        ? (isDark ? AppColorsDark.success : AppColorsLight.success)
        : (isDark ? AppColorsDark.danger : AppColorsLight.danger);

    // تنظيف: طريقة أدق لحساب الإشارة والتعامل مع الأرقام السالبة والموجبة لمنع تداخل الرموز
    final sign = value > 0 ? '+' : (value < 0 ? '−' : '');
    final label = '$sign${value.abs().toStringAsFixed(0)} $unit';

    // تنظيف: إعادة استخدام الـ _Badge الموحدة وتمرير الـ TextStyle المخصص لها
    return _Badge(
      label: label,
      background: bg,
      foreground: fg,
      textStyle: AppTextStyles.buttonS.copyWith(
        color: fg, 
        fontWeight: FontWeight.w700,
      ),
    );
  }
}