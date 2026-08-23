// lib/features/financial/cubit/financial_cubit.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import '../data/financial_repository.dart';
import '../models/partner_model.dart';
import '../models/transaction_model.dart';
import 'financial_state.dart';

class FinancialCubit extends Cubit<FinancialState> {
  FinancialCubit(this._repository) : super(const FinancialInitial());

  final FinancialRepository _repository;

  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  DateTime get currentMonth => _month;

  /// الطلبات التلاتة مستقلة عن بعض، فبتنبعت مع بعض بدل واحد ورا التاني
  /// (كانت بتاخد وقت تلات رحلات شبكة متتالية بدل رحلة وحدة).
  ///
  /// وطالما في بيانات معروضة أصلًا، ما بنرجع لشاشة تحميل فاضية —
  /// بنحدّثها بالخلفية. الـ spinner بيظهر بس أول مرة قبل ما يكون في
  /// أي بيانات (قبل هيك كل انتقال لتبويب المالية كان يمسح الشاشة).
  Future<void> loadMonth([DateTime? month]) async {
    _month = month ?? _month;
    if (state is! FinancialLoaded) emit(const FinancialLoading());
    try {
      final results = await Future.wait([
        _repository.getMonthlyIncome(_month),
        _repository.getExpensesForMonth(_month),
        _repository.getPartners(),
      ]);

      if (isClosed) return;
      emit(
        FinancialLoaded(
          month: _month,
          income: results[0] as double,
          expenses: results[1] as List<TransactionModel>,
          partners: results[2] as List<PartnerModel>,
        ),
      );
    } catch (e, stackTrace) {
      _logError('loadMonth', e, stackTrace);
      if (!isClosed) emit(FinancialError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<String?> addExpense({
    required String description,
    required double amount,
    required DateTime date,
  }) {
    return _runMutation((current) async {
      final expense = await _repository.addExpense(
        description: description,
        amount: amount,
        date: date,
      );
      final isSameMonth =
          expense.date.year == current.month.year &&
          expense.date.month == current.month.month;
      return current.copyWith(
        expenses:
            isSameMonth ? [expense, ...current.expenses] : current.expenses,
      );
    }, logTag: 'addExpense');
  }

  Future<String?> addPartner({
    required String name,
    required double sharePercentage,
  }) {
    return _runMutation((current) async {
      final partner = await _repository.addPartner(
        name: name,
        sharePercentage: sharePercentage,
      );
      return current.copyWith(partners: [...current.partners, partner]);
    }, logTag: 'addPartner');
  }

  Future<String?> updatePartner({
    required String id,
    required String name,
    required double sharePercentage,
  }) {
    return _runMutation((current) async {
      final updated = await _repository.updatePartner(
        id: id,
        name: name,
        sharePercentage: sharePercentage,
      );
      return current.copyWith(
        partners: _replacePartner(current.partners, updated),
      );
    }, logTag: 'updatePartner');
  }

  // withdrawPartnerBalance اتشالت — سلوك السحب لسا مش محدد (بند 4).
  // رح ترجع لما يوصل قرار واضح من زميلك.

  /// نمط موحّد لأي "إجراء سريع" (إضافة/تعديل): يعلّم isMutating،
  /// ينفّذ [action] اللي بيرجع الحالة الجديدة المبنية على الحالة
  /// الحالية، وبيرجّع رسالة الخطأ (أو null لو نجح) عشان الشاشة تتصرف
  /// بدون ما تراقب الـ state مباشرة. أي دالة إجراء جديدة مستقبلًا
  /// بتضيف سطر واحد بس هون بدل تكرار try/catch كامل.
  Future<String?> _runMutation(
    Future<FinancialLoaded> Function(FinancialLoaded current) action, {
    required String logTag,
  }) async {
    final current = state;
    if (current is! FinancialLoaded) return null;

    emit(current.copyWith(isMutating: true));
    try {
      final updated = await action(current);
      if (!isClosed) emit(updated);
      return null;
    } catch (e, stackTrace) {
      _logError(logTag, e, stackTrace);
      if (!isClosed && state is FinancialLoaded) {
        emit((state as FinancialLoaded).copyWith(isMutating: false));
      }
      return ExceptionMapper.mapToMessage(e);
    }
  }

  void _logError(String tag, Object error, StackTrace stackTrace) {
    debugPrint('FinancialCubit $tag Error: $error');
    debugPrint(stackTrace.toString());
  }

  List<PartnerModel> _replacePartner(
    List<PartnerModel> partners,
    PartnerModel updated,
  ) {
    return partners.map((p) => p.id == updated.id ? updated : p).toList();
  }
}
