import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';
import 'package:glow_up/core/errors/error_messages.dart';
import 'package:glow_up/core/localization/app_locale.dart';
import 'package:glow_up/features/notifications/cubit/notification_cubit.dart';
import 'package:glow_up/features/notifications/cubit/notification_state.dart';
import 'package:glow_up/features/notifications/data/notification_repository.dart';
import 'package:glow_up/features/notifications/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// مخزّن بالذاكرة — منورث من الـ repository الحقيقي ومنغطّي دواله،
/// فما منحتاج شبكة ولا Supabase شغّال.
class _FakeRepository extends NotificationRepository {
  _FakeRepository() : super(SupabaseClient('https://test.supabase.co', 'key'));

  List<NotificationModel> rows = [];
  Object? failWith;
  int markAsReadAffected = 1;
  int markAllAffected = 1;
  int fetchCount = 0;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    fetchCount++;
    if (failWith != null) throw failWith!;
    return List.of(rows);
  }

  @override
  Future<int> markAsRead(String id) async {
    if (failWith != null) throw failWith!;
    return markAsReadAffected;
  }

  @override
  Future<int> markAllAsRead() async {
    if (failWith != null) throw failWith!;
    return markAllAffected;
  }
}

NotificationModel note({required String id, bool isRead = false}) =>
    NotificationModel.fromJson({
      SupabaseColumns.id: id,
      SupabaseColumns.trainerId: 't1',
      SupabaseColumns.isRead: isRead,
      SupabaseColumns.message: 'رسالة',
      SupabaseColumns.createdAt: DateTime(2026, 8, 28).toIso8601String(),
    });

void main() {
  setUp(() => AppLocale.current = AppLocale.arabic);

  group('fetchNotifications', () {
    test('loads and counts only the unread ones', () async {
      final repo =
          _FakeRepository()
            ..rows = [
              note(id: '1'),
              note(id: '2', isRead: true),
              note(id: '3'),
            ];
      final cubit = NotificationCubit(repo);

      await cubit.fetchNotifications();

      final state = cubit.state as NotificationLoaded;
      expect(state.notifications, hasLength(3));
      expect(state.unreadCount, 2);
      await cubit.close();
    });

    test('an empty inbox is a loaded state, not an error', () async {
      final cubit = NotificationCubit(_FakeRepository());

      await cubit.fetchNotifications();

      expect(cubit.state, isA<NotificationLoaded>());
      expect((cubit.state as NotificationLoaded).unreadCount, 0);
      await cubit.close();
    });

    test('failures surface a translated message', () async {
      final repo =
          _FakeRepository()
            ..failWith = const PostgrestException(message: 'db', code: '42501');
      final cubit = NotificationCubit(repo);

      await cubit.fetchNotifications();

      expect(cubit.state, isA<NotificationError>());
      expect(
        (cubit.state as NotificationError).message,
        ErrorMessages.permissionDenied,
      );
      await cubit.close();
    });

    test(
      'a refresh keeps the list on screen instead of flashing a spinner',
      () async {
        final repo = _FakeRepository()..rows = [note(id: '1')];
        final cubit = NotificationCubit(repo);
        await cubit.fetchNotifications();

        final states = <NotificationState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.fetchNotifications();
        await sub.cancel();

        expect(
          states.whereType<NotificationLoading>(),
          isEmpty,
          reason: 'once data is on screen a refresh must not drop to loading',
        );
        await cubit.close();
      },
    );
  });

  group('markAsRead', () {
    test('returns null and refreshes when a row was updated', () async {
      final repo = _FakeRepository()..rows = [note(id: '1')];
      final cubit = NotificationCubit(repo);
      await cubit.fetchNotifications();
      final before = repo.fetchCount;

      final error = await cubit.markAsRead('1');

      expect(error, isNull);
      expect(repo.fetchCount, before + 1, reason: 'it should re-fetch');
      await cubit.close();
    });

    test('zero affected rows is reported, not swallowed', () async {
      // صفر صف معناها سياسة RLS مانعة التحديث — قبل هيك كان بينبلع
      // بـ print وبيبيّن للمستخدم تمامًا زي النجاح.
      final repo = _FakeRepository()..markAsReadAffected = 0;
      final cubit = NotificationCubit(repo);

      final error = await cubit.markAsRead('1');

      expect(error, ErrorMessages.permissionDenied);
      await cubit.close();
    });

    test('a thrown error comes back as a message', () async {
      final repo =
          _FakeRepository()
            ..failWith = const PostgrestException(
              message: 'boom',
              code: '23503',
            );
      final cubit = NotificationCubit(repo);

      expect(await cubit.markAsRead('1'), ErrorMessages.foreignKeyViolation);
      await cubit.close();
    });
  });

  group('markAllAsRead', () {
    test('reports a blocked update', () async {
      final repo = _FakeRepository()..markAllAffected = 0;
      final cubit = NotificationCubit(repo);

      expect(await cubit.markAllAsRead(), ErrorMessages.permissionDenied);
      await cubit.close();
    });

    test('succeeds silently when rows were updated', () async {
      final cubit = NotificationCubit(_FakeRepository()..markAllAffected = 4);

      expect(await cubit.markAllAsRead(), isNull);
      await cubit.close();
    });
  });
}
