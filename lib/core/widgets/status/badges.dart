import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import '../../constants/app_enums.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_text_styles.dart';

/// حاوية بصرية موحدة لكل "الشارات الصغيرة الملوّنة" بالتطبيق —
/// نفس البنية بالضبط (padding + radius + نص)، بس بألوان مختلفة حسب الحالة.
class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
    this.textStyle,
  });

  final String label;
  final Color background;
  final Color foreground;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Text(
        label,
        style:
            textStyle ??
            AppTextStyles.tiny.copyWith(
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
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    final (Color bg, Color fg, String label) = switch (status) {
      SubscriptionStatus.active => (
        appColors.successBg,
        appColors.success,
        AppStrings.statusActive,
      ),
      SubscriptionStatus.expiringSoon => (
        appColors.warningBg,
        appColors.warning,
        AppStrings.statusExpiringSoon,
      ),
      SubscriptionStatus.expired => (
        appColors.dangerBg,
        colorScheme.error,
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
    final appColors = context.appColors;

    final (Color bg, Color fg, String label) = switch (program) {
      ProgramType.gym => (
        appColors.infoBg,
        appColors.info,
        AppStrings.programGym,
      ),
      ProgramType.home => (
        appColors.infoBg,
        appColors.info,
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
    final appColors = context.appColors;

    final (Color bg, Color fg, String label) = switch (goal) {
      FitnessGoal.weightLoss => (
        appColors.primarySoftBg,
        appColors.primaryOnSoftBg,
        AppStrings.goalWeightLoss,
      ),
      FitnessGoal.generalFitness => (
        appColors.primarySoftBg,
        appColors.primaryOnSoftBg,
        AppStrings.goalGeneralFitness,
      ),
      FitnessGoal.muscleGain => (
        appColors.infoBg,
        appColors.info,
        AppStrings.goalMuscleGain,
      ),
      FitnessGoal.recovery => (
        appColors.warningBg,
        appColors.warning,
        AppStrings.goalRecovery,
      ),
    };

    return _Badge(label: label, background: bg, foreground: fg);
  }
}

/// شارة صغيرة توضح مقدار التغيّر بقياس معيّن (وزن/خصر/بطن) بين شهرين.
class MeasurementDeltaBadge extends StatelessWidget {
  const MeasurementDeltaBadge({
    super.key,
    required this.value,
    required this.unit,
  });

  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;
    final isImprovement = value <= 0;

    final Color bg = isImprovement ? appColors.successBg : appColors.dangerBg;
    final Color fg = isImprovement ? appColors.success : colorScheme.error;

    final sign = value > 0 ? '+' : (value < 0 ? '−' : '');
    final label = '$sign${value.abs().toStringAsFixed(0)} $unit';

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

/// شارة صغيرة توضح نسبة حصة طرف بقسمة الربح (Financial feature).
class SharePercentageBadge extends StatelessWidget {
  const SharePercentageBadge({
    super.key,
    required this.percentage,
    required this.background,
    required this.foreground,
  });

  final double percentage;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return _Badge(
      label: '${percentage.toStringAsFixed(0)}%',
      background: background,
      foreground: foreground,
      textStyle: AppTextStyles.tiny.copyWith(
        color: foreground,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
