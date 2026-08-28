import 'package:equatable/equatable.dart';

import '../models/measurement.dart';

/// كل الحالات الممكنة لشاشات القياسات (تحميل السجل، حفظ قياس جديد).
sealed class MeasurementsState extends Equatable {
  const MeasurementsState();

  @override
  List<Object?> get props => [];
}

class MeasurementsInitial extends MeasurementsState {
  const MeasurementsInitial();
}

class MeasurementsLoading extends MeasurementsState {
  const MeasurementsLoading();
}

class MeasurementsLoaded extends MeasurementsState {
  const MeasurementsLoaded(this.measurements);

  final List<Measurement> measurements;

  @override
  List<Object?> get props => [measurements];
}

class MeasurementsError extends MeasurementsState {
  const MeasurementsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class MeasurementSaving extends MeasurementsState {
  const MeasurementSaving();
}

class MeasurementSaved extends MeasurementsState {
  const MeasurementSaved();
}
