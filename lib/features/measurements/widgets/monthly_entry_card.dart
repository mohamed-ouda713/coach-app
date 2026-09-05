import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/context_extensions.dart';
import '../../../core/widgets/cards/stat_card.dart';
import '../cubit/measurements_cubit.dart';
import '../models/measurement.dart';

class MonthlyEntryCard extends StatefulWidget {
  const MonthlyEntryCard({super.key, required this.measurement});

  final Measurement measurement;

  @override
  State<MonthlyEntryCard> createState() => _MonthlyEntryCardState();
}

class _MonthlyEntryCardState extends State<MonthlyEntryCard> {
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
              _stat(measurement.weight, AppStrings.measurementsStatWeight),
              const SizedBox(width: AppSpacing.sm),
              _stat(measurement.waistSize, AppStrings.measurementsStatWaist),
              const SizedBox(width: AppSpacing.sm),
              _stat(measurement.abdomenSize, AppStrings.measurementsStatBelly),
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

  Widget _stat(double value, String label) {
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
            (context) => Theme(
              data: ThemeData.dark(),
              child: Scaffold(
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
