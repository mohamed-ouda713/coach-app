import '../../../core/constants/supabase_constants.dart';

/// قياس شهري واحد لعميلة (Feature 4) — مطابق لجدول measurements بقاعدة البيانات.
class Measurement {
  const Measurement({
    this.id,
    required this.subscriberId,
    required this.measurementMonth,
    required this.weight,
    required this.waistSize,
    required this.abdomenSize,
    this.photoBeforeUrl,
    this.photoAfterUrl,
    this.createdAt,
  });

  final String? id;
  final String subscriberId;
  final DateTime measurementMonth;
  final double weight;
  final double waistSize;
  final double abdomenSize;
  final String? photoBeforeUrl;
  final String? photoAfterUrl;
  final DateTime? createdAt;

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json[SupabaseColumns.id] as String?,
      subscriberId: json[SupabaseColumns.subscriberId] as String,
      measurementMonth: DateTime.parse(json[SupabaseColumns.measurementMonth] as String),
      weight: (json[SupabaseColumns.weight] as num).toDouble(),
      waistSize: (json[SupabaseColumns.waistSize] as num).toDouble(),
      abdomenSize: (json[SupabaseColumns.abdomenSize] as num).toDouble(),
      photoBeforeUrl: json[SupabaseColumns.photoBeforeUrl] as String?,
      photoAfterUrl: json[SupabaseColumns.photoAfterUrl] as String?,
      createdAt: json[SupabaseColumns.createdAt] == null
          ? null
          : DateTime.parse(json[SupabaseColumns.createdAt] as String),
    );
  }

  Measurement copyWith({String? photoBeforeUrl, String? photoAfterUrl}) {
    return Measurement(
      id: id,
      subscriberId: subscriberId,
      measurementMonth: measurementMonth,
      weight: weight,
      waistSize: waistSize,
      abdomenSize: abdomenSize,
      photoBeforeUrl: photoBeforeUrl ?? this.photoBeforeUrl,
      photoAfterUrl: photoAfterUrl ?? this.photoAfterUrl,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      SupabaseColumns.subscriberId: subscriberId,
      SupabaseColumns.measurementMonth: measurementMonth.toIso8601String(),
      SupabaseColumns.weight: weight,
      SupabaseColumns.waistSize: waistSize,
      SupabaseColumns.abdomenSize: abdomenSize,
      SupabaseColumns.photoBeforeUrl: photoBeforeUrl,
      SupabaseColumns.photoAfterUrl: photoAfterUrl,
    };
  }
}
