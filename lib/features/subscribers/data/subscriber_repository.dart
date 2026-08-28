// lib/features/subscribers/data/subscriber_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';
import 'package:glow_up/core/errors/exceptions/database_exception.dart';
import '../models/subscriber_model.dart';

class SubscriberRepository {
  SubscriberRepository(this._client);

  final SupabaseClient _client;

  String get _currentTrainerId {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw DatabaseException.permissionDenied();
    }
    return userId;
  }

  Future<List<SubscriberModel>> getAllSubscribers() async {
    final response = await _client
        .from(SupabaseTables.subscribers)
        .select()
        .eq(SupabaseColumns.trainerId, _currentTrainerId)
        .order(SupabaseColumns.createdAt, ascending: false);

    return (response as List)
        .map((row) => SubscriberModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<SubscriberModel> getSubscriberById(String id) async {
    final response =
        await _client
            .from(SupabaseTables.subscribers)
            .select()
            .eq(SupabaseColumns.id, id)
            .eq(SupabaseColumns.trainerId, _currentTrainerId)
            .single();

    return SubscriberModel.fromJson(response);
  }

  Future<SubscriberModel> addSubscriber(SubscriberModel subscriber) async {
    final payload =
        subscriber.toInsertJson()
          ..[SupabaseColumns.trainerId] = _currentTrainerId;

    final response =
        await _client
            .from(SupabaseTables.subscribers)
            .insert(payload)
            .select()
            .single();

    return SubscriberModel.fromJson(response);
  }

  Future<SubscriberModel> updateSubscriber(SubscriberModel subscriber) async {
    final response =
        await _client
            .from(SupabaseTables.subscribers)
            .update(subscriber.toInsertJson())
            .eq(SupabaseColumns.id, subscriber.id)
            .eq(SupabaseColumns.trainerId, _currentTrainerId)
            .select()
            .single();

    return SubscriberModel.fromJson(response);
  }

  Future<void> deleteSubscriber(String id) async {
    await _client
        .from(SupabaseTables.subscribers)
        .delete()
        .eq(SupabaseColumns.id, id)
        .eq(SupabaseColumns.trainerId, _currentTrainerId);
  }

  Future<List<SubscriberModel>> searchSubscribers(String query) async {
    final response = await _client
        .from(SupabaseTables.subscribers)
        .select()
        .eq(SupabaseColumns.trainerId, _currentTrainerId)
        .ilike(SupabaseColumns.fullName, '%${_escapeLikePattern(query)}%')
        .order(SupabaseColumns.createdAt, ascending: false);

    return (response as List)
        .map((row) => SubscriberModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  /// بترجّع نص البحث كما هو، بس بعد ما تعمل escape لرموز LIKE
  /// الخاصة (%, _, \) — عشان لو المستخدمة كتبت واحد منهم بالصدفة
  /// بالاسم يلي بتدوّر عليه، ينحسب كنص حرفي مش كـ wildcard.
  String _escapeLikePattern(String query) {
    return query.replaceAllMapped(
      RegExp(r'[%_\\]'),
      (match) => '\\${match[0]}',
    );
  }
}
