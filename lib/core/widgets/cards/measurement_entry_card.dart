import 'package:flutter/material.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/context_extensions.dart';

/// بطاقة سجل قياس شهري (F3) — الشهر + الوزن/الخصر/البطن.
class MeasurementEntryCard extends StatelessWidget {
  const MeasurementEntryCard({
    super.key,
    required this.monthLabel,
    required this.weight,
    required this.waist,
    required this.belly,
    this.onTap,
  });

  final String monthLabel;
  final double weight;
  final double waist;
  final double belly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.cardLg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lgAlt),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.cardLg),
          border: Border.all(color: appColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthLabel,
              style: AppTextStyles.h5.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.smMd),
            Row(
              children: [
                _measure(
                  weight.toStringAsFixed(1),
                  AppStrings.measurementsWeightLabel,
                  colorScheme.onSurface,
                  appColors.textSecondary,
                ),
                _measure(
                  waist.toStringAsFixed(1),
                  AppStrings.measurementsWaistLabel,
                  colorScheme.onSurface,
                  appColors.textSecondary,
                ),
                _measure(
                  belly.toStringAsFixed(1),
                  AppStrings.measurementsBellyLabel,
                  colorScheme.onSurface,
                  appColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _measure(
    String value,
    String label,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.bodyM.copyWith(
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs / 2),
          Text(label, style: AppTextStyles.tiny.copyWith(color: textSecondary)),
        ],
      ),
    );
  }
}
