// lib/features/subscribers/cubit/subscriber_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import 'package:glow_up/core/errors/exceptions/database_exception.dart';
import 'package:glow_up/core/utils/app_logger.dart';
import '../data/subscriber_repository.dart';
import '../models/subscriber_model.dart';
import 'subscriber_state.dart';

class SubscriberCubit extends Cubit<SubscriberState> {
  SubscriberCubit(this._repository) : super(const SubscriberInitial());

  final SubscriberRepository _repository;

  /// رقم تسلسلي لكل عملية جلب. البحث بيطلق طلب لكل تعديل بالنص (بعد
  /// الـ debounce)، ولو رد طلب قديم بعد طلب أحدث كانت النتيجة القديمة
  /// بتدهس الجديدة. منتجاهل أي رد مش من آخر طلب.
  int _fetchToken = 0;

  Future<void> loadSubscribers() =>
      _fetchAndEmit(_repository.getAllSubscribers);

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
    final token = ++_fetchToken;
    final currentList = _currentSubscribers();
    emit(SubscriberActionInProgress(currentList));
    try {
      final subscribers = await fetch();
      if (isClosed || token != _fetchToken) return;
      emit(SubscriberLoaded(subscribers));
    } catch (e, stackTrace) {
      AppLogger.error('SubscriberCubit.fetch', e, stackTrace);
      if (isClosed || token != _fetchToken) return;
      emit(SubscriberError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> addSubscriber(SubscriberModel subscriber) async {
    final currentList = _currentSubscribers();
    final token = ++_fetchToken;
    emit(SubscriberActionInProgress(currentList));
    try {
      final created = await _repository.addSubscriber(subscriber);
      if (isClosed || token != _fetchToken) return;
      emit(SubscriberActionSuccess([created, ...currentList]));
    } catch (e, stackTrace) {
      AppLogger.error('SubscriberCubit.addSubscriber', e, stackTrace);
      if (isClosed || token != _fetchToken) return;
      emit(SubscriberError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> updateSubscriber(SubscriberModel subscriber) async {
    final currentList = _currentSubscribers();
    final token = ++_fetchToken;
    emit(SubscriberActionInProgress(currentList));
    try {
      final updatedSubscriber = await _repository.updateSubscriber(subscriber);
      if (isClosed || token != _fetchToken) return;
      final updated =
          currentList
              .map((s) => s.id == updatedSubscriber.id ? updatedSubscriber : s)
              .toList();
      emit(SubscriberActionSuccess(updated));
    } catch (e, stackTrace) {
      AppLogger.error('SubscriberCubit.updateSubscriber', e, stackTrace);
      if (isClosed || token != _fetchToken) return;
      emit(SubscriberError(ExceptionMapper.mapToMessage(e)));
    }
  }

  Future<void> deleteSubscriber(String id) async {
    final currentList = _currentSubscribers();
    final token = ++_fetchToken;
    emit(SubscriberActionInProgress(currentList));
    try {
      await _repository.deleteSubscriber(id);
      if (isClosed || token != _fetchToken) return;
      emit(
        SubscriberActionSuccess(currentList.where((s) => s.id != id).toList()),
      );
    } catch (e, stackTrace) {
      AppLogger.error('SubscriberCubit.deleteSubscriber', e, stackTrace);
      if (isClosed || token != _fetchToken) return;
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

  /// بترجع العميل من القائمة المحمّلة أصلاً بالذاكرة، أو null لو مش
  /// موجود (مثلاً القائمة لسا ما انجلبت، أو انفتحت الشاشة من رابط
  /// مباشر). بتستخدمها شاشة الملف الشخصي عشان ترسم فورًا بدل ما
  /// تستنى رحلة شبكة لبيانات موجودة عندها.
  SubscriberModel? findLoadedSubscriber(String id) {
    for (final subscriber in _currentSubscribers()) {
      if (subscriber.id == id) return subscriber;
    }
    return null;
  }

  List<SubscriberModel> _currentSubscribers() {
    final state = this.state;
    if (state is SubscriberLoaded) return state.subscribers;
    if (state is SubscriberActionSuccess) return state.subscribers;
    if (state is SubscriberActionInProgress) return state.subscribers;
    return [];
  }
}
