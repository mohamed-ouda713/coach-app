import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/context_extensions.dart';
import '../../../core/widgets/cards/stat_card.dart';
import '../../../core/widgets/layout/custom_app_bar.dart';
import '../../../core/widgets/status/badges.dart';
import '../cubit/measurements_cubit.dart';
import '../cubit/measurements_state.dart';
import '../models/measurement.dart';

/// شاشة القياسات الموحّدة لعميلة معينة — التقدم الإجمالي + السجل الشهري
/// بشاشة وحدة (بدل شاشتين منفصلتين)، مطابقة لتصميم F3.
class ClientMeasurementsScreen extends StatefulWidget {
  const ClientMeasurementsScreen({
    super.key,
    required this.subscriberId,
    required this.subscriberName,
  });

  final String subscriberId;
  final String subscriberName;

  @override
  State<ClientMeasurementsScreen> createState() => _ClientMeasurementsScreenState();
}

class _ClientMeasurementsScreenState extends State<ClientMeasurementsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MeasurementsCubit>().loadHistory(widget.subscriberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.navMeasurements,
        subtitle: widget.subscriberName,
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 32),
            color: Theme.of(context).colorScheme.primary,
            onPressed:
                () => context.push(
                  '/subscribers/${widget.subscriberId}/measurements/add',
                ),
          ),
        ],
      ),
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
          if (state.measurements.isEmpty) {
            return const Center(child: Text(AppStrings.measurementsEmptyHistory));
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              _buildProgressCard(context, state.measurements),
              const SizedBox(height: AppSpacing.xl),
              Text(
                AppStrings.measurementsMonthlyLog,
                style: AppTextStyles.h5.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.smMd),
              for (final measurement in state.measurements) ...[
                _MonthlyEntryCard(measurement: measurement),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, List<Measurement> measurements) {
    final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
    final inRange =
        measurements.where((m) => m.measurementMonth.isAfter(threeMonthsAgo)).toList()
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
          _progressRow(
            context,
            label: AppStrings.measurementsWeightLabel,
            value: last.weight,
            previous: first.weight,
            delta: last.weight - first.weight,
            unit: AppStrings.unitKg,
          ),
          _progressRow(
            context,
            label: AppStrings.measurementsWaistLabel,
            value: last.waistSize,
            previous: first.waistSize,
            delta: last.waistSize - first.waistSize,
            unit: AppStrings.unitCm,
          ),
          _progressRow(
            context,
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

  Widget _progressRow(
    BuildContext context, {
    required String label,
    required double value,
    required double previous,
    required double delta,
    required String unit,
    bool isLast = false,
  }) {
    final appColors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.smMd),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(bottom: BorderSide(color: appColors.border)),
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
                style: AppTextStyles.bodyS.copyWith(color: appColors.textTertiary),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.arrow_back, size: 14),
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

class _MonthlyEntryCard extends StatelessWidget {
  const _MonthlyEntryCard({required this.measurement});

  final Measurement measurement;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final hasPhotos =
        measurement.photoBeforeUrl != null || measurement.photoAfterUrl != null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lgAlt),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.cardLg),
        border: Border.all(color: appColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMM('ar').format(measurement.measurementMonth),
            style: AppTextStyles.h5.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.smMd),
          Row(
            children: [
              _stat(context, measurement.weight, '${AppStrings.unitKg} وزن'),
              const SizedBox(width: AppSpacing.sm),
              _stat(context, measurement.waistSize, '${AppStrings.unitCm} خصر'),
              const SizedBox(width: AppSpacing.sm),
              _stat(context, measurement.abdomenSize, '${AppStrings.unitCm} بطن'),
            ],
          ),
          if (hasPhotos) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: _photo(context, measurement.photoBeforeUrl, AppStrings.measurementsPhotoBefore)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _photo(context, measurement.photoAfterUrl, AppStrings.measurementsPhotoAfter)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, double value, String label) {
    return Expanded(
      child: StatCard(
        value: value.toStringAsFixed(1),
        label: label,
        size: StatCardSize.small,
      ),
    );
  }

  Widget _photo(BuildContext context, String? url, String label) {
    final appColors = context.appColors;
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: appColors.bgSubtle,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          url != null
              ? Image.network(url, fit: BoxFit.cover)
              : Center(
                child: Text(
                  label,
                  style: AppTextStyles.tiny.copyWith(color: appColors.textSecondary),
                ),
              ),
    );
  }
}
