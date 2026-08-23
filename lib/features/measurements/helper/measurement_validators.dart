import 'package:glow_up/core/constants/app_strings.dart';

abstract class MeasurementFormLimits {
  MeasurementFormLimits._();

  static const double minWeight = 20;
  static const double maxWeight = 300;

  static const double minWaist = 30;
  static const double maxWaist = 250;

  static const double minAbdomen = 30;
  static const double maxAbdomen = 250;
}

abstract class MeasurementValidators {
  MeasurementValidators._();

  static String? weight(String? value) => _numeric(
    value,
    MeasurementFormLimits.minWeight,
    MeasurementFormLimits.maxWeight,
  );

  static String? waist(String? value) => _numeric(
    value,
    MeasurementFormLimits.minWaist,
    MeasurementFormLimits.maxWaist,
  );

  static String? abdomen(String? value) => _numeric(
    value,
    MeasurementFormLimits.minAbdomen,
    MeasurementFormLimits.maxAbdomen,
  );

  static String? _numeric(String? value, double min, double max) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.fieldRequiredShort;
    final parsed = double.tryParse(trimmed);
    if (parsed == null || parsed < min || parsed > max) {
      return AppStrings.measurementsValueInvalid;
    }
    return null;
  }
}
