import 'package:flutter/material.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/context_extensions.dart';
import '../../../core/widgets/status/badges.dart';
import '../models/measurement.dart';

class ClientMeasurementsProgressCard extends StatelessWidget {
  const ClientMeasurementsProgressCard({super.key, required this.measurements});

  final List<Measurement> measurements;

  @override
  Widget build(BuildContext context) {
    final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
    final inRange =
        measurements
            .where(
              (measurement) =>
                  measurement.measurementMonth.isAfter(threeMonthsAgo),
            )
            .toList()
          ..sort((a, b) => a.measurementMonth.compareTo(b.measurementMonth));

    if (inRange.length < 2) {
      return const SizedBox.shrink();
    }

    final first = inRange.first;
    final last = inRange.last;
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lgAlt),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.cardLg),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.measurementsOverallProgress3Months,
            style: AppTextStyles.h5.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ProgressRow(
            label: AppStrings.measurementsWeightLabel,
            value: last.weight,
            previous: first.weight,
            delta: last.weight - first.weight,
            unit: AppStrings.unitKg,
          ),
          _ProgressRow(
            label: AppStrings.measurementsWaistLabel,
            value: last.waistSize,
            previous: first.waistSize,
            delta: last.waistSize - first.waistSize,
            unit: AppStrings.unitCm,
          ),
          _ProgressRow(
            label: AppStrings.measurementsBellyLabel,
            value: last.abdomenSize,
            previous: first.abdomenSize,
            delta: last.abdomenSize - first.abdomenSize,
            unit: AppStrings.unitCm,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.previous,
    required this.delta,
    required this.unit,
    this.isLast = false,
  });

  final String label;
  final double value;
  final double previous;
  final double delta;
  final String unit;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.smMd),
      decoration: BoxDecoration(
        border:
            isLast ? null : Border(bottom: BorderSide(color: appColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyS.copyWith(color: appColors.textSecondary),
          ),
          Row(
            children: [
              MeasurementDeltaBadge(value: delta, unit: unit),
              const SizedBox(width: AppSpacing.sm),
              Text(
                previous.toStringAsFixed(1),
                style: AppTextStyles.bodyS.copyWith(
                  color: appColors.textTertiary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.arrow_back, size: AppSizes.iconXs),
              const SizedBox(width: AppSpacing.xs),
              Text(
                value.toStringAsFixed(1),
                style: AppTextStyles.bodyM.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
