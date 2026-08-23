import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/context_extensions.dart';
import '../../subscribers/cubit/subscriber_cubit.dart';
import '../../subscribers/cubit/subscriber_state.dart';
import '../../subscribers/models/subscriber_model.dart';
import '../../subscribers/widgets/client_picker_field.dart';

class MeasurementsClientPickerScreen extends StatefulWidget {
  const MeasurementsClientPickerScreen({super.key});

  @override
  State<MeasurementsClientPickerScreen> createState() =>
      _MeasurementsClientPickerScreenState();
}

class _MeasurementsClientPickerScreenState
    extends State<MeasurementsClientPickerScreen> {
  @override
  void initState() {
    super.initState();
    if (context.read<SubscriberCubit>().state is SubscriberInitial) {
      context.read<SubscriberCubit>().loadSubscribers();
    }
  }

  void _onSelected(SubscriberModel? subscriber) {
    if (subscriber == null) return;
    context.push(
      '/subscribers/${subscriber.id}/measurements',
      extra: subscriber.fullName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ColoredBox(
      color: appColors.bgSubtle,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<SubscriberCubit>().loadSubscribers(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lgAlt),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.cardLg),
                border: Border.all(color: appColors.border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: AppSizes.iconDisplay,
                    color: appColors.textTertiary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.measurementsPickClientHint,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyM.copyWith(
                      color: appColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocBuilder<SubscriberCubit, SubscriberState>(
                    builder: (context, state) {
                      if (state is SubscriberInitial ||
                          state is SubscriberLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final subscribers = switch (state) {
                        SubscriberLoaded(:final subscribers) => subscribers,
                        SubscriberActionSuccess(:final subscribers) => subscribers,
                        SubscriberActionInProgress(:final subscribers) => subscribers,
                        _ => const <SubscriberModel>[],
                      };

                      if (subscribers.isEmpty) {
                        return Text(
                          AppStrings.noMatchingClients,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyM.copyWith(
                            color: appColors.textTertiary,
                          ),
                        );
                      }

                      return ClientPickerField(
                        subscribers: subscribers,
                        value: null,
                        onChanged: _onSelected,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
