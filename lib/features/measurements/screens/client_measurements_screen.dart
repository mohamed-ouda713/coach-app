import 'package:glow_up/core/localization/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/context_extensions.dart';
import '../../../core/widgets/cards/stat_card.dart';
import '../../../core/widgets/layout/custom_app_bar.dart';
import '../../../core/widgets/status/app_success_snackbar.dart';
import '../../../core/widgets/status/badges.dart';
import '../cubit/measurements_cubit.dart';
import '../cubit/measurements_state.dart';
import '../models/measurement.dart';

class ClientMeasurementsScreen extends StatefulWidget {
  const ClientMeasurementsScreen({
    super.key,
    required this.subscriberId,
    required this.subscriberName,
    this.justAdded = false,
  });

  final String subscriberId;
  final String subscriberName;

  final bool justAdded;

  @override
  State<ClientMeasurementsScreen> createState() =>
      _ClientMeasurementsScreenState();
}

class _ClientMeasurementsScreenState extends State<ClientMeasurementsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MeasurementsCubit>().loadHistory(widget.subscriberId);

    if (widget.justAdded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppSuccessSnackbar.show(context, AppStrings.measurementAddedSuccess);
        }
      });
    }
  }

  Future<void> _refresh() =>
      context.read<MeasurementsCubit>().loadHistory(widget.subscriberId);

  void _openAddMeasurement() {
    context.push(
      '/subscribers/${widget.subscriberId}/measurements/add',
      extra: widget.subscriberName,
    );
  }

  Widget _buildBody(BuildContext context, MeasurementsState state) {
    const scrollPhysics = AlwaysScrollableScrollPhysics();
    const listPadding = EdgeInsets.all(AppSpacing.screenPadding);

    if (state is MeasurementsError) {
      return ListView(
        physics: scrollPhysics,
        padding: listPadding,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(state.message, textAlign: TextAlign.center),
        ],
      );
    }

    if (state is! MeasurementsLoaded) {
      return ListView(physics: scrollPhysics, children: const []);
    }

    if (state.measurements.isEmpty) {
      return ListView(
        physics: scrollPhysics,
        padding: listPadding,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(
            AppStrings.measurementsEmptyHistory,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return ListView(
      physics: scrollPhysics,
      padding: listPadding,
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
            icon: const Icon(Icons.add_circle, size: AppSizes.iconXxl),
            color: Theme.of(context).colorScheme.primary,
            onPressed: _openAddMeasurement,
          ),
        ],
      ),
      body: BlocBuilder<MeasurementsCubit, MeasurementsState>(
        builder: (context, state) {
          if (state is MeasurementsLoading || state is MeasurementsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    List<Measurement> measurements,
  ) {
    final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
    final inRange =
        measurements
            .where((m) => m.measurementMonth.isAfter(threeMonthsAgo))
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

class _MonthlyEntryCard extends StatefulWidget {
  const _MonthlyEntryCard({required this.measurement});

  final Measurement measurement;

  @override
  State<_MonthlyEntryCard> createState() => _MonthlyEntryCardState();
}

class _MonthlyEntryCardState extends State<_MonthlyEntryCard> {
  Future<String>? _beforeUrlFuture;
  Future<String>? _afterUrlFuture;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MeasurementsCubit>();
    final beforeUrl = widget.measurement.photoBeforeUrl;
    final afterUrl = widget.measurement.photoAfterUrl;
    _beforeUrlFuture = beforeUrl == null ? null : cubit.photoUrl(beforeUrl);
    _afterUrlFuture = afterUrl == null ? null : cubit.photoUrl(afterUrl);
  }

  @override
  Widget build(BuildContext context) {
    final measurement = widget.measurement;
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
            DateFormat.yMMMM(
              AppLocale.code,
            ).format(measurement.measurementMonth),
            style: AppTextStyles.h5.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.smMd),
          Row(
            children: [
              _stat(
                context,
                measurement.weight,
                AppStrings.measurementsStatWeight,
              ),
              const SizedBox(width: AppSpacing.sm),
              _stat(
                context,
                measurement.waistSize,
                AppStrings.measurementsStatWaist,
              ),
              const SizedBox(width: AppSpacing.sm),
              _stat(
                context,
                measurement.abdomenSize,
                AppStrings.measurementsStatBelly,
              ),
            ],
          ),
          if (hasPhotos) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _photo(
                    context,
                    _beforeUrlFuture,
                    AppStrings.measurementsPhotoBefore,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _photo(
                    context,
                    _afterUrlFuture,
                    AppStrings.measurementsPhotoAfter,
                  ),
                ),
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

  void _openFullImage(BuildContext context, String url, String label) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              backgroundColor: AppColors.photoViewerBackground,
              appBar: AppBar(
                title: Text(label),
                backgroundColor: AppColors.photoViewerBackground,
                foregroundColor: AppColors.white,
              ),
              body: Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const CircularProgressIndicator(
                        color: AppColors.white,
                      );
                    },
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _photoBox(BuildContext context, {required Widget child}) {
    return Container(
      height: AppSizes.photoThumb,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appColors.bgSubtle,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _photo(BuildContext context, Future<String>? urlFuture, String label) {
    final appColors = context.appColors;

    final empty = _photoBox(
      context,
      child: Text(
        label,
        style: AppTextStyles.tiny.copyWith(color: appColors.textSecondary),
      ),
    );

    if (urlFuture == null) return empty;

    final loading = Shimmer.fromColors(
      baseColor: appColors.bgSubtle,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: Container(
        height: AppSizes.photoThumb,
        width: double.infinity,
        decoration: BoxDecoration(
          color: appColors.bgSubtle,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
    );

    return FutureBuilder<String>(
      future: urlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loading;
        }
        if (snapshot.hasError || snapshot.data == null) {
          debugPrint('DEBUG signed url error: ${snapshot.error}');
          return empty;
        }

        final url = snapshot.data!;
        return GestureDetector(
          onTap: () => _openFullImage(context, url, label),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Image.network(
              url,
              height: AppSizes.photoThumb,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return loading;
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint('DEBUG photo load error for $url: $error');
                return empty;
              },
            ),
          ),
        );
      },
    );
  }
}
