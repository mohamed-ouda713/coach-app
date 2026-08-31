import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/supabase_constants.dart';
import '../../../core/errors/exceptions/database_exception.dart';
import '../../../core/utils/app_logger.dart';
import '../models/measurement.dart';

/// طبقة الاتصال المباشر بجدول القياسات — الأخطاء بتطلع لفوق للـ Cubit.
class MeasurementRepository {
  MeasurementRepository(this._client);

  final SupabaseClient _client;

  String get _currentTrainerId {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw DatabaseException.permissionDenied();
    }
    return userId;
  }

  /// كل استعلامات القياسات بتمر عبر العملاء يلي بيملكهم المدرب الحالي.
  ///
  /// باقي الـ repositories بتفلتر بـ `trainer_id` مباشرة، بس جدول
  /// القياسات ما فيه العمود — فمنربط عبر `subscribers` بدل ما نعتمد
  /// على RLS لحالها. طبقة ثانية من الحماية، ونفس سلوك باقي الفيتشرز.
  Future<void> _assertOwnsSubscriber(String subscriberId) async {
    final rows = await _client
        .from(SupabaseTables.subscribers)
        .select(SupabaseColumns.id)
        .eq(SupabaseColumns.id, subscriberId)
        .eq(SupabaseColumns.trainerId, _currentTrainerId)
        .limit(1);

    if ((rows as List).isEmpty) {
      throw DatabaseException.permissionDenied();
    }
  }

  Future<void> addMeasurement(Measurement measurement) async {
    await _assertOwnsSubscriber(measurement.subscriberId);
    await _client
        .from(SupabaseTables.measurements)
        .insert(measurement.toJson());
  }

  Future<List<Measurement>> getMeasurementHistory(String subscriberId) async {
    await _assertOwnsSubscriber(subscriberId);

    final response = await _client
        .from(SupabaseTables.measurements)
        .select()
        .eq(SupabaseColumns.subscriberId, subscriberId)
        .order(SupabaseColumns.measurementMonth, ascending: false);

    return (response as List)
        .map((row) => Measurement.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<String> uploadPhoto(File file, String fileName) async {
    await _client.storage
        .from(SupabaseBuckets.measurementPhotos)
        .upload(fileName, file);
    return fileName;
  }

  /// بتنستدعى لما يفشل حفظ القياس بعد ما الصور انرفعت — بدونها بتضل
  /// الصور اليتيمة بالـ bucket للأبد.
  Future<void> deletePhotos(List<String> paths) async {
    if (paths.isEmpty) return;
    try {
      await _client.storage
          .from(SupabaseBuckets.measurementPhotos)
          .remove(paths);
    } catch (e) {
      // التنظيف أفضل جهد — فشله ما بيغيّر النتيجة يلي بيشوفها المستخدم.
      AppLogger.warn('MeasurementRepository.deletePhotos', e);
    }
  }

  Future<String> getPhotoSignedUrl(String path) {
    return _client.storage
        .from(SupabaseBuckets.measurementPhotos)
        .createSignedUrl(path, _signedUrlTtlSeconds);
  }

  static const int _signedUrlTtlSeconds = 3600;
}
