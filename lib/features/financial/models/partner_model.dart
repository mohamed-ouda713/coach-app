// lib/features/financial/models/partner_model.dart

import 'package:equatable/equatable.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';

/// طرف من أطراف قسمة الربح (شريك) — نسبة حصته من الربح. الرصيد
/// مش مخزّن، بيتحسب دايمًا = صافي الربح الشهري × النسبة (شوف
/// PartnerSplitCard._calculatedBalance).
class PartnerModel extends Equatable {
  const PartnerModel({
    required this.id,
    required this.trainerId,
    required this.name,
    required this.sharePercentage,
    required this.createdAt,
  });

  final String id;
  final String trainerId;
  final String name;
  final double sharePercentage;
  final DateTime createdAt;

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json[SupabaseColumns.id] as String,
      trainerId: json[SupabaseColumns.trainerId] as String,
      name: json[SupabaseColumns.name] as String,
      sharePercentage:
          (json[SupabaseColumns.sharePercentage] as num).toDouble(),
      createdAt: DateTime.parse(json[SupabaseColumns.createdAt] as String),
    );
  }

  /// بدون id/trainerId/createdAt — دول بتتحدد من السيرفر أو من الـ repository.
  Map<String, dynamic> toInsertJson() {
    return {
      SupabaseColumns.name: name,
      SupabaseColumns.sharePercentage: sharePercentage,
    };
  }

  PartnerModel copyWith({
    String? name,
    double? sharePercentage,
  }) {
    return PartnerModel(
      id: id,
      trainerId: trainerId,
      name: name ?? this.name,
      sharePercentage: sharePercentage ?? this.sharePercentage,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, trainerId, name, sharePercentage, createdAt];
}