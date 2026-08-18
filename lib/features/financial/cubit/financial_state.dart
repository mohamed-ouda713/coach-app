// lib/features/financial/cubit/financial_state.dart

import 'package:equatable/equatable.dart';
import '../models/partner_model.dart';
import '../models/transaction_model.dart';

sealed class FinancialState extends Equatable {
  const FinancialState();

  @override
  List<Object?> get props => [];
}

class FinancialInitial extends FinancialState {
  const FinancialInitial();
}

class FinancialLoading extends FinancialState {
  const FinancialLoading();
}

class FinancialLoaded extends FinancialState {
  const FinancialLoaded({
    required this.month,
    required this.income,
    required this.expenses,
    required this.partners,
    this.isMutating = false,
  });

  final DateTime month;
  final double income;
  final List<TransactionModel> expenses;
  final List<PartnerModel> partners;

  /// true أثناء تنفيذ إجراء سريع (إضافة مصروف/طرف، سحب رصيد) — عشان
  /// نعطّل الأزرار بدون ما نخسر البيانات المعروضة على الشاشة.
  final bool isMutating;

  double get totalExpenses =>
      expenses.fold<double>(0, (sum, e) => sum + e.amount);

  double get netProfit => income - totalExpenses;

  FinancialLoaded copyWith({
    double? income,
    List<TransactionModel>? expenses,
    List<PartnerModel>? partners,
    bool? isMutating,
  }) {
    return FinancialLoaded(
      month: month,
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
      partners: partners ?? this.partners,
      isMutating: isMutating ?? this.isMutating,
    );
  }

  @override
  List<Object?> get props => [month, income, expenses, partners, isMutating];
}

class FinancialError extends FinancialState {
  const FinancialError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}