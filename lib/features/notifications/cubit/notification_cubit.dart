import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';

import '../data/notification_repository.dart';
import '../services/app_badge_service.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._repository) : super(NotificationInitial());

  final NotificationRepository _repository;

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await _repository.getNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      await AppBadgeService.update(unreadCount);
      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(NotificationError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final affected = await _repository.markAsRead(notificationId);
      if (affected == 0 && kDebugMode) {
        print(
          'markAsRead affected 0 rows for $notificationId — check RLS update policy',
        );
      }
      await fetchNotifications();
    } catch (e) {
      if (kDebugMode) {
        print('markAsRead failed for $notificationId: $e');
      }
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final affected = await _repository.markAllAsRead();
      if (affected == 0 && kDebugMode) {
        print('markAllAsRead affected 0 rows — check RLS update policy');
      }
      await fetchNotifications();
    } catch (e) {
      if (kDebugMode) {
        print('markAllAsRead failed: $e');
      }
    }
  }
}
