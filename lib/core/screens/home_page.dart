// lib/core/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/custom_text_link.dart';
import 'package:glow_up/core/widgets/layout/bottom_nav_bar.dart';
import 'package:glow_up/core/widgets/layout/custom_app_bar.dart';
import 'package:glow_up/core/widgets/layout/home_top_bar.dart';
import 'package:glow_up/features/auth/cubit/auth_cubit.dart';
import 'package:glow_up/features/auth/cubit/auth_state.dart';
import 'package:glow_up/features/financial/cubit/financial_cubit.dart';
import 'package:glow_up/features/financial/cubit/financial_state.dart';
import 'package:glow_up/features/financial/helper/finance_formatters.dart';
import 'package:glow_up/features/financial/screens/financial_screen.dart';
import 'package:glow_up/features/financial/screens/widgets/add_expense_dialog.dart';
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

  static const int _financesTabIndex = 3;

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

  /// كل التبويبات محفوظة حيّة بالذاكرة عبر IndexedStack (مش بتنعاد
  /// بناها كل ما تتنقلي بينها) — يعني لو ضفتي مثلاً عميلة جديدة من
  /// تبويب العملاء، تبويب المالية (يلي فيه الدخل المحسوب منها) ما
  /// رح يعرف إنه في تغيير تلقائيًا. لهيك بنجدّد بيانات المالية يدويًا
  /// كل مرة توصلها المستخدمة، بدل ما تعتمد فقط على initState (يلي
  /// بينفّذ مرة وحدة بعمر الشاشة كله).
  void _onTabTap(int index) {
    setState(() => _currentIndex = index);
    if (index == _financesTabIndex) {
      context.read<FinancialCubit>().loadMonth();
    }
  }

  PreferredSizeWidget _buildAppBar() {
    if (_currentIndex == _financesTabIndex) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(78),
        child: BlocBuilder<FinancialCubit, FinancialState>(
          builder: (context, state) {
            final month = state is FinancialLoaded
                ? state.month
                : context.read<FinancialCubit>().currentMonth;
            return CustomAppBar(
              title: AppStrings.navFinances,
              subtitle: FinanceFormatters.monthYear(month),
              height: 78,
              leading: CustomTextLink(
                textButton: '',
                title: AppStrings.actionAdd,
                onPressed: () => AddExpenseDialog.show(context),
              ),
            );
          },
        ),
      );
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(HomeTopBar.height),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final fullName = state is AuthAuthenticated
              ? (state.user.userMetadata?['full_name'] as String?)
              : null;
          final userName = (fullName != null && fullName.trim().isNotEmpty)
              ? fullName.trim()
              : AppStrings.appName;
          return HomeTopBar(
            userName: userName,
            onProfileTap: () => context.push(AppRoutes.profile),
            onAddTap: () => context.push(AppRoutes.addSubscriber),
            onNotificationsTap: () => _showComingSoon(context),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const SubscribersListScreen(),
          _PlaceholderTab(icon: _tabs[1].icon, label: _tabs[1].label),
          _PlaceholderTab(icon: _tabs[2].icon, label: _tabs[2].label),
          const FinancialScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
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