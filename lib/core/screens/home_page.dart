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
import 'package:glow_up/features/subscribers/screens/subscribers_list_screen.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _tabs = [
    (icon: Icons.people, label: AppStrings.navClients),
    (icon: Icons.bar_chart, label: AppStrings.navMeasurements),
    (icon: Icons.notifications, label: AppStrings.navNotifications),
    (icon: Icons.attach_money, label: AppStrings.navFinances),
  ];

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(AppStrings.comingSoon),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(AppSpacing.lgAlt),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                context.push(AppRoutes.addSubscriber);
              },
              onNotificationsTap: () => _showComingSoon(context),
            );
          },
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const SubscribersListScreen(),
          _PlaceholderTab(icon: _tabs[1].icon, label: _tabs[1].label),
          _PlaceholderTab(icon: _tabs[2].icon, label: _tabs[2].label),
          _PlaceholderTab(icon: _tabs[3].icon, label: _tabs[3].label),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
