import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/supabase_constants.dart';
import '../../../core/errors/exception_mapper.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/image_compressor.dart';
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
      final measurements = await _repository.getMeasurementHistory(
        subscriberId,
      );
      if (!isClosed) emit(MeasurementsLoaded(measurements));
    } catch (e, stackTrace) {
      AppLogger.error('MeasurementsCubit.loadHistory', e, stackTrace);
      if (!isClosed) emit(MeasurementsError(ExceptionMapper.mapToMessage(e)));
    }
  }

  /// بترفع الصور أول (بعد ضغطها) وبعدين بتحفظ الصف. لو فشل الحفظ،
  /// بتمسح الصور يلي انرفعت — قبل هيك كانت بتضل يتيمة بالـ bucket، وأكتر
  /// حالة بتصير فيها هي إعادة المحاولة على نفس الشهر (خطأ 23505).
  Future<void> saveMeasurement(
    Measurement measurement, {
    File? photoBefore,
    File? photoAfter,
  }) async {
    emit(const MeasurementSaving());

    final uploadedPaths = <String>[];
    try {
      var toSave = measurement;
      final stamp = DateTime.now().millisecondsSinceEpoch;

      if (photoBefore != null) {
        final path = await _uploadPhoto(
          photoBefore,
          '${measurement.subscriberId}_before_$stamp.jpg',
        );
        uploadedPaths.add(path);
        toSave = toSave.copyWith(photoBeforeUrl: path);
      }

      if (photoAfter != null) {
        final path = await _uploadPhoto(
          photoAfter,
          '${measurement.subscriberId}_after_$stamp.jpg',
        );
        uploadedPaths.add(path);
        toSave = toSave.copyWith(photoAfterUrl: path);
      }

      await _repository.addMeasurement(toSave);
      if (!isClosed) emit(const MeasurementSaved());
    } on supabase.PostgrestException catch (e, stackTrace) {
      AppLogger.error('MeasurementsCubit.saveMeasurement', e, stackTrace);
      await _repository.deletePhotos(uploadedPaths);
      if (isClosed) return;
      emit(
        MeasurementsError(
          e.code == '23505'
              ? AppStrings.measurementsDuplicateMonth
              : ExceptionMapper.mapToMessage(e),
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('MeasurementsCubit.saveMeasurement', e, stackTrace);
      await _repository.deletePhotos(uploadedPaths);
      if (!isClosed) emit(MeasurementsError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<String> _uploadPhoto(File file, String fileName) async {
    final compressed = await ImageCompressor.compress(file);
    return _repository.uploadPhoto(compressed, fileName);
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
