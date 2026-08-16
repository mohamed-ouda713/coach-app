import 'package:glow_up/core/localization/app_locale.dart';
// lib/features/subscribers/screens/client_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/async/app_future_builder.dart';
import 'package:glow_up/core/widgets/cards/stat_card.dart';
import 'package:glow_up/core/widgets/layout/custom_app_bar.dart';
import 'package:glow_up/core/widgets/media/app_avatar.dart';
import 'package:glow_up/core/widgets/status/badges.dart';
import 'package:glow_up/core/widgets/Buttons/Primary_Buttons/primary_Buttons.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/custom_text_link.dart';

import '../cubit/subscriber_cubit.dart';
import '../models/subscriber_model.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key, required this.clientId});

  final String clientId;

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  late Future<SubscriberModel> _subscriberFuture;

  @override
  void initState() {
    super.initState();
    _loadSubscriber();
  }

  void _loadSubscriber() {
    setState(() {
      _subscriberFuture = context.read<SubscriberCubit>().fetchSubscriberById(
        widget.clientId,
      );
    });
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final result = await context.push('/clients/${widget.clientId}/edit');
    if (mounted) {
      _loadSubscriber();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgSubtle,
      appBar: CustomAppBar(
        title: AppStrings.clientProfileScreenTitle,
        leading: CustomTextLink(
          textButton: '',
          title: AppStrings.actionEdit,
          onPressed: () => _navigateToEdit(context),
        ),
        actions: [
          CustomTextLink(
            textButton: '',
            title: AppStrings.navClients,
            icon: Icons.chevron_left,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: AppFutureBuilder<SubscriberModel>(
          future: _subscriberFuture,
          errorMessage: AppStrings.defaultErrorMessage,
          onRetry: _loadSubscriber,
          builder: (context, subscriber) {
            return RefreshIndicator(
              onRefresh: () async => _loadSubscriber(),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lgAlt),
                children: [
                  _ProfileHeroCard(subscriber: subscriber),
                  const SizedBox(height: AppSpacing.mdLg),
                  _SubscriptionCard(subscriber: subscriber),
                  const SizedBox(height: AppSpacing.lgAlt),
                  _ActionsRow(
                    subscriber: subscriber,
                    onEditTap: () => _navigateToEdit(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({required this.subscriber});

  final SubscriberModel subscriber;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: context.appColors.bgSubtle.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: subscriber.fullName, size: AvatarSize.large),
              const SizedBox(width: AppSpacing.lgAlt),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscriber.fullName,
                      style: AppTextStyles.h1.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        GoalBadge(goal: subscriber.goal),
                        ProgramBadge(program: subscriber.program),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lgAlt),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  value: subscriber.age?.toString() ?? '—',
                  label: AppStrings.clientAge,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: StatCard(
                  value:
                      subscriber.weight != null
                          ? '${subscriber.weight!.toStringAsFixed(0)} ${AppStrings.unitKg}'
                          : '—',
                  label: AppStrings.clientWeight,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: StatCard(
                  value:
                      subscriber.height != null
                          ? '${subscriber.height!.toStringAsFixed(0)} ${AppStrings.unitCm}'
                          : '—',
                  label: AppStrings.clientHeight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({required this.subscriber});

  final SubscriberModel subscriber;

  DateFormat get _dateFormat => DateFormat('d MMMM yyyy', AppLocale.code);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: context.appColors.bgSubtle.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(status: subscriber.status),
              Text(
                AppStrings.subscriptionDetails,
                style: AppTextStyles.h5.copyWith(color: colorScheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.mdLg),
          _row(
            context,
            label: AppStrings.subscriptionEndDate,
            value: _dateFormat.format(subscriber.subscriptionEndDate),
            showDivider: true,
          ),
          _row(
            context,
            label: AppStrings.subscriptionStartDate,
            value: _dateFormat.format(subscriber.subscriptionStartDate),
            showDivider: true,
          ),
          _row(
            context,
            label: AppStrings.subscriptionAmount,
            value:
                '${subscriber.subscriptionFee.toStringAsFixed(0)} ${AppStrings.financeCurrency}',
            valueSuffix: subscriber.note,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required String label,
    required String value,
    String? valueSuffix,
    required bool showDivider,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration:
          showDivider
              ? BoxDecoration(
                border: Border(bottom: BorderSide(color: appColors.bgSubtle)),
              )
              : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                value,
                style: AppTextStyles.bodyM.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (valueSuffix != null && valueSuffix.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  valueSuffix,
                  style: AppTextStyles.caption.copyWith(
                    color: appColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: appColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({required this.subscriber, required this.onEditTap});

  final SubscriberModel subscriber;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                title: AppStrings.addMeasurementCta,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                onTap:
                    () => context.push(
                      '/subscribers/${subscriber.id}/measurements/add',
                      extra: subscriber.fullName,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.mdLg),
            SizedBox(
              width: 88,
              child: PrimaryButton(
                title: AppStrings.actionEdit,
                backgroundColor: context.appColors.bgSubtle,
                textColor: context.appColors.textSecondary,
                onTap: onEditTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.mdLg),
        CustomTextLink(
          title: AppStrings.navMeasurements,
          icon: Icons.bar_chart,
          onPressed:
              () => context.push(
                '/subscribers/${subscriber.id}/measurements',
                extra: subscriber.fullName,
              ),
        ),
      ],
    );
  }
}