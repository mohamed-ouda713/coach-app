// lib/features/subscribers/cubit/subscriber_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import 'package:glow_up/core/errors/exceptions/database_exception.dart';
import '../data/subscriber_repository.dart';
import '../models/subscriber_model.dart';
import 'subscriber_state.dart';

class SubscriberCubit extends Cubit<SubscriberState> {
  SubscriberCubit(this._repository) : super(const SubscriberInitial());

  final SubscriberRepository _repository;

  Future<void> loadSubscribers() => _fetchAndEmit(_repository.getAllSubscribers);

  Future<void> searchSubscribers(String query) {
    if (query.trim().isEmpty) return loadSubscribers();
    return _fetchAndEmit(() => _repository.searchSubscribers(query));
  }

  /// نمط موحّد لأي عملية "جلب قائمة" (تحميل كامل أو بحث): تحافظ على
  /// القائمة الحالية أثناء الجلب (بدل مسحها بـ state فاضي)، وترجع
  /// القائمة القديمة عند الفشل بدل تفريغ الشاشة بالكامل.
  Future<void> _fetchAndEmit(
    Future<List<SubscriberModel>> Function() fetch,
  ) async {
    final currentList = _currentSubscribers();
    emit(SubscriberActionInProgress(currentList));
    try {
      final subscribers = await fetch();
      emit(SubscriberLoaded(subscribers));
    } catch (e) {
      emit(SubscriberError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> addSubscriber(SubscriberModel subscriber) async {
    final currentList = _currentSubscribers();
    emit(SubscriberActionInProgress(currentList));
    try {
      final created = await _repository.addSubscriber(subscriber);
      emit(SubscriberActionSuccess([created, ...currentList]));
    } catch (e) {
      emit(SubscriberError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> updateSubscriber(SubscriberModel subscriber) async {
    final currentList = _currentSubscribers();
    emit(SubscriberActionInProgress(currentList));
    try {
      final updatedSubscriber = await _repository.updateSubscriber(subscriber);
      final updated = currentList
          .map((s) => s.id == updatedSubscriber.id ? updatedSubscriber : s)
          .toList();
      emit(SubscriberActionSuccess(updated));
    } catch (e) {
      emit(SubscriberError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> deleteSubscriber(String id) async {
    final currentList = _currentSubscribers();
    emit(SubscriberActionInProgress(currentList));
    try {
      await _repository.deleteSubscriber(id);
      emit(SubscriberActionSuccess(
        currentList.where((s) => s.id != id).toList(),
      ));
    } catch (e) {
      emit(SubscriberError(ExceptionMapper.mapToMessage(e)));
    }
  }

  /// بترجع الـ Future مباشرة (مش state) لأنها بتُستخدم مع
  /// AppFutureBuilder بشاشات الملف الشخصي والتعديل — بس زي أي عملية
  /// تانية بهاد الـ Cubit، أي استثناء لازم يمر عبر ExceptionMapper
  /// قبل ما يوصل للواجهة، عشان ما يبين رسالة خام غير مُترجمة ولا
  /// يعتمد على مين استدعاها يمسك الاستثناء صح.
  Future<SubscriberModel> fetchSubscriberById(String id) async {
    try {
      return await _repository.getSubscriberById(id);
    } catch (e) {
      throw DatabaseException(ExceptionMapper.mapToMessage(e));
    }
  }

  List<SubscriberModel> _currentSubscribers() {
    final state = this.state;
    if (state is SubscriberLoaded) return state.subscribers;
    if (state is SubscriberActionSuccess) return state.subscribers;
    if (state is SubscriberActionInProgress) return state.subscribers;
    return [];
  }
}