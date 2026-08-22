// lib/core/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/layout/bottom_nav_bar.dart';
import 'package:glow_up/core/widgets/layout/home_top_bar.dart';
import 'package:glow_up/features/auth/cubit/auth_cubit.dart';
import 'package:glow_up/features/auth/cubit/auth_state.dart';
import 'package:glow_up/features/measurements/screens/measurements_client_picker_screen.dart';
import 'package:glow_up/features/notifications/cubit/notification_cubit.dart';
import 'package:glow_up/features/notifications/data/notification_repository.dart';
import 'package:glow_up/features/notifications/screens/notifications_screen.dart';
import 'package:glow_up/features/subscribers/screens/subscribers_list_screen.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static List<({IconData icon, String label})> get _tabs => [
    (icon: Icons.people, label: AppStrings.navClients),
    (icon: Icons.bar_chart, label: AppStrings.navMeasurements),
    (icon: Icons.notifications, label: AppStrings.navNotifications),
    (icon: Icons.attach_money, label: AppStrings.navFinances),
  ];

  static const _notificationsTabIndex = 2;

  /// التبويبات كلها بتتبنى مرة وحدة جوا IndexedStack، فجلب الإشعارات
  /// بيصير لحظة فتح الشاشة الرئيسية. لهيك منعيد الجلب كل ما ينفتح
  /// التبويب عشان تظهر الإشعارات يلي وصلت بعد ما فتح التطبيق.
  void _onTabSelected(BuildContext context, int index) {
    setState(() => _currentIndex = index);
    if (index == _notificationsTabIndex) {
      context.read<NotificationCubit>().fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              NotificationCubit(
                  NotificationRepository(Supabase.instance.client),
                )
                ..fetchNotifications(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(HomeTopBar.height),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final fullName =
                    state is AuthAuthenticated
                        ? (state.user.userMetadata?['full_name'] as String?)
                        : null;
                final userName =
                    (fullName != null && fullName.trim().isNotEmpty)
                        ? fullName.trim()
                        : AppStrings.appName;
                return HomeTopBar(
                  userName: userName,
                  onProfileTap: () => context.push(AppRoutes.profile),
                  onAddTap: () {
                    if (_currentIndex == 1) {
                      context.push(AppRoutes.addMeasurementPickClient);
                    } else {
                      context.push(AppRoutes.addSubscriber);
                    }
                  },
                  onNotificationsTap:
                      () => _onTabSelected(context, _notificationsTabIndex),
                );
              },
            ),
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              const SubscribersListScreen(),
              const MeasurementsClientPickerScreen(),
              const NotificationsScreen(),
              _PlaceholderTab(icon: _tabs[3].icon, label: _tabs[3].label),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) => _onTabSelected(context, index),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconDisplay,
            color: context.appColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '$label — ${AppStrings.comingSoon}',
            style: AppTextStyles.bodyM.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
