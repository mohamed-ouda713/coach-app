// lib/features/financial/data/financial_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';
import 'package:glow_up/core/errors/exceptions/database_exception.dart';
import '../models/partner_model.dart';
import '../models/transaction_model.dart';

class FinancialRepository {
  FinancialRepository(this._client);

  final SupabaseClient _client;

  String get _currentTrainerId {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw DatabaseException.permissionDenied();
    }
    return userId;
  }

  String _isoDate(DateTime date) => date.toIso8601String().split('T').first;

  /// مصروفات الشهر المحدّد (بداية الشهر لحد بداية الشهر يلي بعده)،
  /// مرتبة تنازليًا حسب التاريخ.
  Future<List<TransactionModel>> getExpensesForMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final response = await _client
        .from(SupabaseTables.expenses)
        .select()
        .eq(SupabaseColumns.trainerId, _currentTrainerId)
        .gte(SupabaseColumns.date, _isoDate(start))
        .lt(SupabaseColumns.date, _isoDate(end))
        .order(SupabaseColumns.date, ascending: false);

    return (response as List)
        .map(
          (row) => TransactionModel.fromJson({
            ...(row as Map<String, dynamic>),
            SupabaseColumns.type: 'expense',
          }),
        )
        .toList();
  }

  /// الدخل الشهري = مجموع رسوم اشتراكات العملاء يلي تاريخ بدء
  /// اشتراكهم وقع بنفس الشهر المحدّد. (مؤكَّد — هاد التعريف المقصود،
  /// مش bug: الاشتراك السنوي بيدخل كامل بشهر واحد، والتجديدات ما
  /// بتنعد.)
  Future<double> getMonthlyIncome(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final response = await _client
        .from(SupabaseTables.subscribers)
        .select(SupabaseColumns.subscriptionFee)
        .eq(SupabaseColumns.trainerId, _currentTrainerId)
        .gte(SupabaseColumns.subscriptionStartDate, _isoDate(start))
        .lt(SupabaseColumns.subscriptionStartDate, _isoDate(end));

    return (response as List).fold<double>(0, (sum, row) {
      final fee = (row as Map)[SupabaseColumns.subscriptionFee];
      return sum + (fee is num ? fee.toDouble() : 0.0);
    });
  }

  Future<TransactionModel> addExpense({
    required String description,
    required double amount,
    required DateTime date,
  }) async {
    final payload = {
      SupabaseColumns.trainerId: _currentTrainerId,
      SupabaseColumns.description: description,
      SupabaseColumns.amount: amount,
      SupabaseColumns.date: _isoDate(date),
    };

    final response =
        await _client
            .from(SupabaseTables.expenses)
            .insert(payload)
            .select()
            .single();

    return TransactionModel.fromJson({
      ...response,
      SupabaseColumns.type: 'expense',
    });
  }

  Future<List<PartnerModel>> getPartners() async {
    final response = await _client
        .from(SupabaseTables.partners)
        .select()
        .eq(SupabaseColumns.trainerId, _currentTrainerId)
        .order(SupabaseColumns.createdAt, ascending: true);

    return (response as List)
        .map((row) => PartnerModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<PartnerModel> addPartner({
    required String name,
    required double sharePercentage,
  }) async {
    final payload = {
      SupabaseColumns.trainerId: _currentTrainerId,
      SupabaseColumns.name: name,
      SupabaseColumns.sharePercentage: sharePercentage,
    };

    final response =
        await _client
            .from(SupabaseTables.partners)
            .insert(payload)
            .select()
            .single();

    return PartnerModel.fromJson(response);
  }

  Future<PartnerModel> updatePartner({
    required String id,
    required String name,
    required double sharePercentage,
  }) async {
    final response =
        await _client
            .from(SupabaseTables.partners)
            .update({
              SupabaseColumns.name: name,
              SupabaseColumns.sharePercentage: sharePercentage,
            })
            .eq(SupabaseColumns.id, id)
            .eq(SupabaseColumns.trainerId, _currentTrainerId)
            .select()
            .single();

    return PartnerModel.fromJson(response);
  }

  // withdrawPartnerBalance اتشالت — سلوك السحب لسا مش محدد (بند 4).
  // رح ترجع لما يوصل قرار واضح من زميلك.
}
