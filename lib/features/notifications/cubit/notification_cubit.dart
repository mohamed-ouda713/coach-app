import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/features/notifications/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  NotificationCubit() : super(NotificationInitial());

  // 1. جلب الإشعارات الخاصة بالمدرب
  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(NotificationError("المستخدم غير مسجل"));
        return;
      }

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('trainer_id', userId)
          .order('created_at', ascending: false);

      final notifications = (response as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList();

      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  // 2. تحديث الإشعار كـ "تمت القراءة"
  Future<void> markAsRead(String notificationId) async {
    try {
      final updated = await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId)
          .select();

      if (updated.isEmpty && kDebugMode) {
        print(
          'markAsRead affected 0 rows for $notificationId — check RLS update policy',
        );
      }

      // إعادة تحديث القائمة محلياً
      await fetchNotifications();
    } catch (e) {
      if (kDebugMode) {
        print('markAsRead failed for $notificationId: $e');
      }
    }
  }

  // 3. تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final updated = await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('trainer_id', userId)
          .select();

      if (updated.isEmpty && kDebugMode) {
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