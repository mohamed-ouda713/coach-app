import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/cards/measurement_entry_card.dart';
import '../cubit/measurements_cubit.dart';
import '../cubit/measurements_state.dart';

/// شاشة السجل الشهري لقياسات عميلة معينة (F3).
class MeasurementHistoryScreen extends StatefulWidget {
  const MeasurementHistoryScreen({super.key, required this.subscriberId});

  final String subscriberId;

  @override
  State<MeasurementHistoryScreen> createState() => _MeasurementHistoryScreenState();
}

class _MeasurementHistoryScreenState extends State<MeasurementHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MeasurementsCubit>().loadHistory(widget.subscriberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.measurementsMonthlyLog)),
      body: BlocBuilder<MeasurementsCubit, MeasurementsState>(
        builder: (context, state) {
          if (state is MeasurementsLoading || state is MeasurementsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MeasurementsError) {
            return Center(child: Text(state.message));
          }
          if (state is MeasurementsLoaded) {
            if (state.measurements.isEmpty) {
              return const Center(child: Text(AppStrings.measurementsEmptyHistory));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: state.measurements.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final measurement = state.measurements[index];
                return MeasurementEntryCard(
                  monthLabel: DateFormat.yMMMM('ar').format(measurement.measurementMonth),
                  weight: measurement.weight,
                  waist: measurement.waistSize,
                  belly: measurement.abdomenSize,
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
