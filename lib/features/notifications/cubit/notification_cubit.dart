import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/errors/error_messages.dart';
import 'package:glow_up/core/errors/exception_mapper.dart';
import 'package:glow_up/core/utils/app_logger.dart';

import '../data/notification_repository.dart';
import '../services/app_badge_service.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._repository) : super(NotificationInitial());

  final NotificationRepository _repository;

  /// الـ spinner بيظهر بس لما ما يكون في إشعارات معروضة أصلاً. لو في
  /// قائمة على الشاشة (تحديث بعد "تعليم كمقروء" مثلاً) بنحدّثها بمكانها
  /// بدل ما نمسحها ونرجّع شاشة تحميل.
  Future<void> fetchNotifications() async {
    if (state is! NotificationLoaded) emit(NotificationLoading());
    try {
      final notifications = await _repository.getNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      await AppBadgeService.update(unreadCount);
      if (isClosed) return;
      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('NotificationCubit.fetchNotifications', e, stackTrace);
      if (!isClosed) emit(NotificationError(ExceptionMapper.mapToMessage(e)));
    }
  }

  /// بترجع رسالة خطأ لو فشلت، أو null لو نجحت — الشاشة بتعرضها كـ
  /// snackbar. قبل هيك كان الفشل بينبلع بـ print، فـ badge ما بينمسح
  /// بسبب سياسة RLS كان بيبيّن للمستخدم تمامًا زي النجاح.
  Future<String?> markAsRead(String notificationId) async {
    return _runUpdate(
      () => _repository.markAsRead(notificationId),
      logTag: 'markAsRead($notificationId)',
    );
  }

  Future<String?> markAllAsRead() async {
    return _runUpdate(_repository.markAllAsRead, logTag: 'markAllAsRead');
  }

  /// [update] بترجع عدد الصفوف يلي انعدّلت فعليًا. صفر معناها الصف مش
  /// موجود أو سياسة RLS مانعة التحديث — وهاد فشل حقيقي لازم المستخدم
  /// يعرف فيه، مش حالة نجاح صامتة.
  Future<String?> _runUpdate(
    Future<int> Function() update, {
    required String logTag,
  }) async {
    try {
      final affected = await update();
      if (affected == 0) {
        AppLogger.error(
          'NotificationCubit.$logTag',
          'affected 0 rows — check the RLS update policy',
        );
        return ErrorMessages.permissionDenied;
      }
      await fetchNotifications();
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('NotificationCubit.$logTag', e, stackTrace);
      return ExceptionMapper.mapToMessage(e);
    }
  }
}
