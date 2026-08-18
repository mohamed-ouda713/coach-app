// lib/features/financial/models/partner_model.dart

import 'package:equatable/equatable.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';

/// طرف من أطراف قسمة الربح (شريك) — نسبة حصته من الربح ورصيده الحالي.
class PartnerModel extends Equatable {
  const PartnerModel({
    required this.id,
    required this.trainerId,
    required this.name,
    required this.sharePercentage,
    required this.balance,
    required this.createdAt,
  });

  final String id;
  final String trainerId;
  final String name;
  final double sharePercentage;
  final double balance;
  final DateTime createdAt;

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json[SupabaseColumns.id] as String,
      trainerId: json[SupabaseColumns.trainerId] as String,
      name: json[SupabaseColumns.name] as String,
      sharePercentage:
          (json[SupabaseColumns.sharePercentage] as num).toDouble(),
      balance: (json[SupabaseColumns.balance] as num).toDouble(),
      createdAt: DateTime.parse(json[SupabaseColumns.createdAt] as String),
    );
  }

  /// بدون id/trainerId/createdAt — دول بتتحدد من السيرفر أو من الـ repository.
  Map<String, dynamic> toInsertJson() {
    return {
      SupabaseColumns.name: name,
      SupabaseColumns.sharePercentage: sharePercentage,
      SupabaseColumns.balance: balance,
    };
  }

  PartnerModel copyWith({
    String? name,
    double? sharePercentage,
    double? balance,
  }) {
    return PartnerModel(
      id: id,
      trainerId: trainerId,
      name: name ?? this.name,
      sharePercentage: sharePercentage ?? this.sharePercentage,
      balance: balance ?? this.balance,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        trainerId,
        name,
        sharePercentage,
        balance,
        createdAt,
      ];
}