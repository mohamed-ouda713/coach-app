import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

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
    } catch (e) {
      emit(MeasurementsError(ExceptionMapper.mapToMessage(e)));
    }
  }
}
