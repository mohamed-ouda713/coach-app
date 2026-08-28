// lib/features/financial/models/transaction_model.dart

import 'package:equatable/equatable.dart';
import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';

/// سطر مالي واحد بجدول expenses — بيتسجل فيه المصروفات (والدخل اليدوي
/// لو احتجناه لاحقًا)، ومُميّز بـ [type].
class TransactionModel extends Equatable {
  const TransactionModel({
    required this.id,
    required this.trainerId,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String trainerId;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;
  final DateTime createdAt;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json[SupabaseColumns.id] as String,
      trainerId: json[SupabaseColumns.trainerId] as String,
      amount: (json[SupabaseColumns.amount] as num).toDouble(),
      description: json[SupabaseColumns.description] as String,
      date: DateTime.parse(json[SupabaseColumns.date] as String),
      type: _typeFromDb(json[SupabaseColumns.type] as String),
      createdAt: DateTime.parse(json[SupabaseColumns.createdAt] as String),
    );
  }

  /// بدون id/trainerId/createdAt — دول بتتحدد من السيرفر أو من الـ repository.
  Map<String, dynamic> toInsertJson() {
    return {
      SupabaseColumns.amount: amount,
      SupabaseColumns.description: description,
      SupabaseColumns.date: date.toIso8601String().split('T').first,
      SupabaseColumns.type: _typeToDb(type),
    };
  }

  @override
  List<Object?> get props => [
    id,
    trainerId,
    amount,
    description,
    date,
    type,
    createdAt,
  ];
}

TransactionType _typeFromDb(String value) => switch (value) {
  'income' => TransactionType.income,
  'expense' => TransactionType.expense,
  _ => throw FormatException('Unknown transaction type: $value'),
};

String _typeToDb(TransactionType type) => switch (type) {
  TransactionType.income => 'income',
  TransactionType.expense => 'expense',
};
