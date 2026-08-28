import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/supabase_constants.dart';
import '../models/measurement.dart';

/// طبقة الاتصال المباشر بجدول القياسات — الأخطاء بتطلع لفوق للـ Cubit.
class MeasurementRepository {
  MeasurementRepository(this._client);

  final SupabaseClient _client;

  Future<void> addMeasurement(Measurement measurement) async {
    await _client
        .from(SupabaseTables.measurements)
        .insert(measurement.toJson());
  }

  Future<List<Measurement>> getMeasurementHistory(String subscriberId) async {
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

  Future<String> getPhotoSignedUrl(String path) {
    return _client.storage
        .from(SupabaseBuckets.measurementPhotos)
        .createSignedUrl(path, _signedUrlTtlSeconds);
  }

  static const int _signedUrlTtlSeconds = 3600;
}
