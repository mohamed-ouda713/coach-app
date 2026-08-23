import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/supabase_constants.dart';
import '../../../core/errors/exception_mapper.dart';
import '../data/measurement_repository.dart';
import '../models/measurement.dart';
import 'measurements_state.dart';

/// يدير تحميل سجل القياسات وحفظ قياس جديد (مع رفع صوره لو موجودة).
class MeasurementsCubit extends Cubit<MeasurementsState> {
  MeasurementsCubit(this._repository) : super(const MeasurementsInitial());

  final MeasurementRepository _repository;

  Future<void> loadHistory(String subscriberId) async {
    emit(const MeasurementsLoading());
    try {
      final measurements = await _repository.getMeasurementHistory(subscriberId);
      emit(MeasurementsLoaded(measurements));
    } catch (e) {
      emit(MeasurementsError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> saveMeasurement(
    Measurement measurement, {
    File? photoBefore,
    File? photoAfter,
  }) async {
    emit(const MeasurementSaving());
    try {
      var toSave = measurement;
      final stamp = DateTime.now().millisecondsSinceEpoch;

      if (photoBefore != null) {
        final url = await _repository.uploadPhoto(
          photoBefore,
          '${measurement.subscriberId}_before_$stamp.jpg',
        );
        toSave = toSave.copyWith(photoBeforeUrl: url);
      }

      if (photoAfter != null) {
        final url = await _repository.uploadPhoto(
          photoAfter,
          '${measurement.subscriberId}_after_$stamp.jpg',
        );
        toSave = toSave.copyWith(photoAfterUrl: url);
      }

      await _repository.addMeasurement(toSave);
      emit(const MeasurementSaved());
    } on supabase.PostgrestException catch (e) {
      emit(MeasurementsError(
        e.code == '23505'
            ? AppStrings.measurementsDuplicateMonth
            : ExceptionMapper.mapToMessage(e),
      ));
    } catch (e) {
      emit(MeasurementsError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<String> photoUrl(String storedValue) {
    return _repository.getPhotoSignedUrl(_storagePathOf(storedValue));
  }

  static String _storagePathOf(String storedValue) {
    const marker = '/${SupabaseBuckets.measurementPhotos}/';
    final markerIndex = storedValue.indexOf(marker);
    return markerIndex == -1
        ? storedValue
        : storedValue.substring(markerIndex + marker.length);
  }
}
