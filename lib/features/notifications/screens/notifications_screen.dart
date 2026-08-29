import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_snackbar.dart';
import 'package:glow_up/features/notifications/cubit/notification_cubit.dart';
import 'package:glow_up/features/notifications/cubit/notification_state.dart';
import 'package:glow_up/features/notifications/models/notification_model.dart';
import 'package:glow_up/features/notifications/widgets/notifications_empty_state.dart';
import 'package:glow_up/features/notifications/widgets/notifications_error.dart';
import 'package:glow_up/features/notifications/widgets/notifications_list.dart';
import 'package:glow_up/features/notifications/widgets/notifications_loading.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';

/// محتوى تبويب الإشعارات — بدون Scaffold/AppBar خاص فيه، لأنه بينعرض
/// جوا IndexedStack تبع HomePage يلي أصلاً عندها شريط علوي وسفلي مشترك.
/// الـ NotificationCubit بتتوفر من HomePage عشان تقدر تعيد الجلب
/// كل ما ينفتح التبويب.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  /// الضغط على الإشعار بيعلّمه مقروء وبيفتح ملف العميل المرتبط فيه،
  /// لأنه هو الإجراء يلي بده ياه الكوتش (تجديد الاشتراك/متابعة العميل).
  void _onNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!notification.isRead) {
      // بدون await — فتح ملف العميل أهم من انتظار تعليم الإشعار كمقروء،
      // بس لو فشل التعليم منعرضه بدل ما يضيع بصمت.
      _markAsRead(context, notification);
    }

    final subscriberId = notification.subscriberId;
    if (subscriberId != null && subscriberId.isNotEmpty) {
      context.push(AppRoutes.clientProfilePath(subscriberId));
    }
  }

  Future<void> _markAsRead(
    BuildContext context,
    NotificationModel notification,
  ) async {
    final error = await context.read<NotificationCubit>().markAsRead(
      notification.id,
    );
    if (error != null && context.mounted) {
      AppErrorSnackbar.show(context, error);
    }
  }

  Future<void> _markAllAsRead(BuildContext context) async {
    final error = await context.read<NotificationCubit>().markAllAsRead();
    if (error != null && context.mounted) {
      AppErrorSnackbar.show(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        // NotificationInitial كمان بتعني "لسا عم نجيب" — قبل هيك كانت
        // بتوقع بآخر return وتعرض شاشة فاضية بدون أي مؤشر تحميل.
        if (state is NotificationLoading || state is NotificationInitial) {
          return const NotificationsLoading();
        }

        if (state is NotificationError) {
          return NotificationsError(message: state.message);
        }

        if (state is NotificationLoaded) {
          return RefreshIndicator(
            onRefresh:
                () => context.read<NotificationCubit>().fetchNotifications(),
            child:
                state.notifications.isEmpty
                    ? LayoutBuilder(
                      builder:
                          (context, constraints) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: constraints.maxHeight,
                                child: const NotificationsEmptyState(),
                              ),
                            ],
                          ),
                    )
                    : Column(
                      children: [
                        if (state.unreadCount > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lgAlt,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () => _markAllAsRead(context),
                                child: Text(
                                  AppStrings.notificationsMarkAllRead,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: NotificationsList(
                            notifications: state.notifications,
                            onNotificationTap:
                                (notification) =>
                                    _onNotificationTap(context, notification),
                            onMarkAsRead:
                                (notification) =>
                                    _markAsRead(context, notification),
                          ),
                        ),
                      ],
                    ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
