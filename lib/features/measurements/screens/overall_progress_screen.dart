import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/cards/stat_card.dart';
import '../../../core/widgets/status/badges.dart';
import '../cubit/measurements_cubit.dart';
import '../cubit/measurements_state.dart';

/// شاشة التقدم الإجمالي خلال آخر 3 أشهر — بتقارن أول وآخر قياس بالمدة (F3).
class OverallProgressScreen extends StatefulWidget {
  const OverallProgressScreen({super.key, required this.subscriberId});

  final String subscriberId;

  @override
  State<OverallProgressScreen> createState() => _OverallProgressScreenState();
}

class _OverallProgressScreenState extends State<OverallProgressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MeasurementsCubit>().loadHistory(widget.subscriberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.measurementsOverallProgress3Months)),
      body: BlocBuilder<MeasurementsCubit, MeasurementsState>(
        builder: (context, state) {
          if (state is MeasurementsLoading || state is MeasurementsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MeasurementsError) {
            return Center(child: Text(state.message));
          }
          if (state is! MeasurementsLoaded) {
            return const SizedBox.shrink();
          }

          final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
          final inRange = state.measurements
              .where((m) => m.measurementMonth.isAfter(threeMonthsAgo))
              .toList()
            ..sort((a, b) => a.measurementMonth.compareTo(b.measurementMonth));

          if (inRange.length < 2) {
            return const Center(child: Text(AppStrings.measurementsNotEnoughForProgress));
          }

          final first = inRange.first;
          final last = inRange.last;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _progressRow(
                  label: AppStrings.measurementsWeightLabel,
                  value: last.weight,
                  delta: last.weight - first.weight,
                  unit: AppStrings.unitKg,
                ),
                const SizedBox(height: AppSpacing.lgAlt),
                _progressRow(
                  label: AppStrings.measurementsWaistLabel,
                  value: last.waistSize,
                  delta: last.waistSize - first.waistSize,
                  unit: AppStrings.unitCm,
                ),
                const SizedBox(height: AppSpacing.lgAlt),
                _progressRow(
                  label: AppStrings.measurementsBellyLabel,
                  value: last.abdomenSize,
                  delta: last.abdomenSize - first.abdomenSize,
                  unit: AppStrings.unitCm,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _progressRow({
    required String label,
    required double value,
    required double delta,
    required String unit,
  }) {
    return Row(
      children: [
        Expanded(child: StatCard(value: value.toStringAsFixed(1), label: label)),
        const SizedBox(width: AppSpacing.md),
        MeasurementDeltaBadge(value: delta, unit: unit),
      ],
    );
  }
}
