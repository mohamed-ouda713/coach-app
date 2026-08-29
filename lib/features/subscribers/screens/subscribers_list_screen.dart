// lib/features/subscribers/screens/subscribers_list_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/cards/client_card.dart';
import 'package:glow_up/core/widgets/cards/stat_card.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_view.dart';
import 'package:glow_up/core/widgets/inputs/search_widget.dart';
import 'package:glow_up/core/widgets/selection/selectable_chip.dart';
import 'package:go_router/go_router.dart';

import '../cubit/subscriber_cubit.dart';
import '../cubit/subscriber_state.dart';
import '../models/subscriber_model.dart';

enum _StatusFilter { all, active, expiringSoon, expired }

class SubscribersListScreen extends StatefulWidget {
  const SubscribersListScreen({super.key});

  @override
  State<SubscribersListScreen> createState() => _SubscribersListScreenState();
}

class _SubscribersListScreenState extends State<SubscribersListScreen> {
  final _searchController = TextEditingController();
  _StatusFilter _activeFilter = _StatusFilter.all;
  Timer? _debounce;

  List<SubscriberModel> _lastKnownSubscribers = const [];

  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    context.read<SubscriberCubit>().loadSubscribers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _refresh() {
    final query = _searchController.text.trim();
    final cubit = context.read<SubscriberCubit>();
    return query.isEmpty
        ? cubit.loadSubscribers()
        : cubit.searchSubscribers(query);
  }

  /// بتحتفظ بآخر قائمة معروفة عشان ما نمسح الشاشة أثناء تحديث بالخلفية
  /// أو عند خطأ مؤقت.
  void _cacheState(SubscriberState state) {
    switch (state) {
      case SubscriberLoaded(:final subscribers):
      case SubscriberActionSuccess(:final subscribers):
        setState(() {
          _lastKnownSubscribers = subscribers;
          _hasLoadedOnce = true;
        });
      case SubscriberActionInProgress(:final subscribers):
        setState(() => _lastKnownSubscribers = subscribers);
      case SubscriberError():
        setState(() => _hasLoadedOnce = true);
      case SubscriberInitial():
      case SubscriberLoading():
        break;
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      context.read<SubscriberCubit>().searchSubscribers(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.appColors.bgSubtle,
      child: SafeArea(
        // الكاش بينتحدّث بالـ listener مش بالـ builder: تعديل حالة
        // الـ State جوّا build بيخالف شرط إن build تكون خالية من الأثر
        // الجانبي، وهاد بالضبط مصدر الأخطاء يلي ما بتنعاد.
        child: BlocConsumer<SubscriberCubit, SubscriberState>(
          listener: (context, state) => _cacheState(state),
          builder: (context, state) {
            if (!_hasLoadedOnce) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SubscriberError && _lastKnownSubscribers.isEmpty) {
              return AppErrorView(
                message: state.message,
                onRetry:
                    () => context.read<SubscriberCubit>().loadSubscribers(),
              );
            }

            final isRefreshing = state is SubscriberActionInProgress;

            return _buildContent(
              _lastKnownSubscribers,
              isRefreshing: isRefreshing,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    List<SubscriberModel> subscribers, {
    bool isRefreshing = false,
  }) {
    final total = subscribers.length;
    // نشط = كل يلي اشتراكه ما انتهى، بما فيهم يلي قربوا ينتهوا.
    final active = subscribers.where((s) => s.isActive).length;
    final expiring =
        subscribers
            .where((s) => s.status == SubscriptionStatus.expiringSoon)
            .length;

    final filtered = _applyFilter(subscribers);

    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildStatsRow(total, active, expiring),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lgAlt,
            AppSpacing.mdLg,
            AppSpacing.lgAlt,
            AppSpacing.xs,
          ),
          child: SearchWidget(
            controller: _searchController,
            hintText: AppStrings.clientsSearchHint,
            onChanged: _onSearchChanged,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildFilterRow(),
        const SizedBox(height: AppSpacing.sm),

        SizedBox(
          height: 3,
          child:
              isRefreshing
                  ? const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                  )
                  : null,
        ),
        const SizedBox(height: AppSpacing.sm),

        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child:
                filtered.isEmpty
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: AppSpacing.xxl),
                        AppErrorView(
                          message: AppStrings.noMatchingClients,
                          icon: Icons.people_outline,
                          tone: AppErrorViewTone.empty,
                        ),
                      ],
                    )
                    : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lgAlt,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder:
                          (_, __) => const SizedBox(height: AppSpacing.smMd),
                      itemBuilder: (context, index) {
                        final subscriber = filtered[index];
                        final card = ClientCard(
                          name: subscriber.fullName,
                          goal: subscriber.goal,
                          status: subscriber.status,
                          onTap:
                              () => context.push('/clients/${subscriber.id}'),
                        );

                        return subscriber.status == SubscriptionStatus.expired
                            ? Opacity(opacity: 0.45, child: card)
                            : card;
                      },
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(int total, int active, int expiring) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lgAlt,
        AppSpacing.mdLg,
        AppSpacing.lgAlt,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              value: total.toString(),
              label: AppStrings.clientsStatTotal,
              size: StatCardSize.small,
              backgroundColor: appColors.primarySoftBg,
              valueColor: appColors.primaryOnSoftBg,
            ),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: StatCard(
              value: active.toString(),
              label: AppStrings.clientsStatActive,
              size: StatCardSize.small,
              backgroundColor: appColors.successBg,
              valueColor: appColors.success,
            ),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: StatCard(
              value: expiring.toString(),
              label: AppStrings.clientsStatExpiring,
              size: StatCardSize.small,
              backgroundColor: appColors.warningBg,
              valueColor: appColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = {
      _StatusFilter.all: AppStrings.clientsFilterAll,
      _StatusFilter.active: AppStrings.statusActive,
      _StatusFilter.expiringSoon: AppStrings.statusExpiringSoon,
      _StatusFilter.expired: AppStrings.statusExpired,
    };

    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgAlt),
        children:
            filters.entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.sm,
                    ),
                    child: SelectableChip(
                      label: entry.value,
                      isSelected: _activeFilter == entry.key,
                      onTap: () => setState(() => _activeFilter = entry.key),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  List<SubscriberModel> _applyFilter(List<SubscriberModel> subscribers) {
    return switch (_activeFilter) {
      _StatusFilter.all => subscribers,
      // "نشط" بيشمل يلي بينتهي قريباً — لسا اشتراكه شغّال. و"ينتهي
      // قريباً" فلتر أضيق جوّاته، مش بديل عنه.
      _StatusFilter.active => subscribers.where((s) => s.isActive).toList(),
      _StatusFilter.expiringSoon =>
        subscribers
            .where((s) => s.status == SubscriptionStatus.expiringSoon)
            .toList(),
      _StatusFilter.expired =>
        subscribers
            .where((s) => s.status == SubscriptionStatus.expired)
            .toList(),
    };
  }
}
