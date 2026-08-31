// lib/core/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/widgets/buttons/custom_text_link.dart';
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
import 'package:glow_up/features/measurements/screens/measurements_client_picker_screen.dart';
import 'package:glow_up/features/notifications/cubit/notification_cubit.dart';
import 'package:glow_up/features/notifications/cubit/notification_state.dart';
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

  static const _notificationsTabIndex = 2;
  static const _financesTabIndex = 3;

  /// التبويبات كلها بتتبنى مرة وحدة جوا IndexedStack (مش بتنعاد بناها
  /// كل ما تتنقّل بينها) — فمنجدّد بيانات الإشعارات/المالية يدويًا كل
  /// ما يوصل المستخدم لتبويبهم، بدل ما تعتمد فقط على initState (يلي
  /// بينفّذ مرة وحدة بعمر الشاشة كله).
  void _onTabSelected(BuildContext context, int index) {
    setState(() => _currentIndex = index);
    if (index == _notificationsTabIndex) {
      context.read<NotificationCubit>().fetchNotifications();
    } else if (index == _financesTabIndex) {
      context.read<FinancialCubit>().loadMonth();
    }
  }

  PreferredSizeWidget _buildAppBar() {
    if (_currentIndex == _financesTabIndex) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(AppSizes.financeAppBarHeight),
        child: BlocBuilder<FinancialCubit, FinancialState>(
          builder: (context, state) {
            final month =
                state is FinancialLoaded
                    ? state.month
                    : context.read<FinancialCubit>().currentMonth;
            return CustomAppBar(
              title: AppStrings.navFinances,
              subtitle: FinanceFormatters.monthYear(month),
              height: AppSizes.financeAppBarHeight,
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
          final fullName =
              state is AuthAuthenticated
                  ? (state.user.userMetadata?['full_name'] as String?)
                  : null;
          final userName =
              (fullName != null && fullName.trim().isNotEmpty)
                  ? fullName.trim()
                  : AppStrings.appName;
          return BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, notificationState) {
              final unreadCount =
                  notificationState is NotificationLoaded
                      ? notificationState.unreadCount
                      : 0;
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
                unreadNotificationsCount: unreadCount,
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => NotificationCubit(
            NotificationRepository(Supabase.instance.client),
          )..fetchNotifications(),
      child: Builder(
        builder:
            (context) => Scaffold(
              appBar: _buildAppBar(),
              body: IndexedStack(
                index: _currentIndex,
                children: [
                  const SubscribersListScreen(),
                  const MeasurementsClientPickerScreen(),
                  const NotificationsScreen(),
                  const FinancialScreen(),
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
