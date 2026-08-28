// lib/features/notifications/data/notification_repository.dart

import 'package:glow_up/core/constants/supabase_constants.dart';
import 'package:glow_up/core/errors/exceptions/database_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/notification_model.dart';

class NotificationRepository {
  NotificationRepository(this._client);

  final SupabaseClient _client;

  String get _currentTrainerId {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw DatabaseException.permissionDenied();
    }
    return userId;
  }

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _client
        .from(SupabaseTables.notifications)
        .select()
        .eq(SupabaseColumns.trainerId, _currentTrainerId)
        .order(SupabaseColumns.createdAt, ascending: false);

    return (response as List)
        .map((row) => NotificationModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  /// بترجع عدد الصفوف يلي فعليًا انعدّلت — صفر معناها الصف مش موجود
  /// أو سياسة RLS مانعة التحديث.
  Future<int> markAsRead(String notificationId) async {
    final updated =
        await _client
            .from(SupabaseTables.notifications)
            .update({SupabaseColumns.isRead: true})
            .eq(SupabaseColumns.id, notificationId)
            .eq(SupabaseColumns.trainerId, _currentTrainerId)
            .select();

    return updated.length;
  }

  Future<int> markAllAsRead() async {
    final updated =
        await _client
            .from(SupabaseTables.notifications)
            .update({SupabaseColumns.isRead: true})
            .eq(SupabaseColumns.trainerId, _currentTrainerId)
            .eq(SupabaseColumns.isRead, false)
            .select();

    return updated.length;
  }
}
