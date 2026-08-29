import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/utils/app_logger.dart';

/// بينتبّه لضغط المستخدم على إشعار — بيمرّر `subscriberId` للراوتر.
typedef NotificationTapHandler = void Function(String subscriberId);

/// لازم تكون top-level function (مش method) عشان Firebase يقدر يستدعيها
/// بـ isolate منفصل لما التطبيق مسكّر.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // ما منعمل شي هون غير التسجيل: الإشعار بينعرض تلقائيًا من نظام
  // التشغيل، والقائمة داخل التطبيق بتتحدّث من قاعدة البيانات عند الفتح.
  AppLogger.info('FCM background', message.messageId ?? 'no id');
}

class NotificationService {
  NotificationService._();
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// لازم يطابق default_notification_channel_id بـ AndroidManifest.
  static const String channelId = 'high_importance_channel';

  /// اسم الـ drawable بـ android/app/src/main/res/drawable-*.
  static const String androidIcon = 'ic_stat_notification';

  static const String _subscriberIdKey = 'subscriberId';

  static NotificationTapHandler? _onTap;

  static AndroidNotificationChannel get _channel => AndroidNotificationChannel(
    channelId,
    AppStrings.notificationsChannelName,
    description: AppStrings.notificationsChannelDescription,
    importance: Importance.high,
  );

  /// إعداد القناة والمستمعين — بتنستدعى وقت الإقلاع.
  ///
  /// **ما بتطلب إذن الإشعارات**؛ هاد شغل [requestPermission] وبينستدعى
  /// بعد تسجيل الدخول. iOS بيسمح بـ prompt واحد بس طول عمر التثبيت،
  /// فطلبه فوق شاشة البداية بيحرق الفرصة على فاضي.
  static Future<void> initialize() async {
    try {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);

      await _localNotifications.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings(androidIcon),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: _onLocalNotificationTapped,
      );

      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_showForegroundNotification);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);
    } catch (e, stackTrace) {
      // فشل إعداد الإشعارات ما بيوقف التطبيق — باقي الميزات بتضل شغالة.
      AppLogger.error('NotificationService.initialize', e, stackTrace);
    }
  }

  /// بتنستدعى بعد أول تسجيل دخول ناجح، مش وقت الإقلاع.
  static Future<bool> requestPermission() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
      AppLogger.info('FCM permission', settings.authorizationStatus.name);
      return granted;
    } catch (e) {
      AppLogger.warn('NotificationService.requestPermission', e);
      return false;
    }
  }

  /// بتسجّل الدالة يلي بتتنفّذ لما تنضغط الإشعار (الراوتر بيمرّرها).
  static void setTapHandler(NotificationTapHandler handler) {
    _onTap = handler;
  }

  /// لو انفتح التطبيق من إشعار وهو مسكّر بالكامل، الرسالة بتكون مخزّنة
  /// هون — بترجع الـ subscriberId لو موجود.
  static Future<String?> initialSubscriberId() async {
    try {
      final message = await _fcm.getInitialMessage();
      return subscriberIdFrom(message?.data);
    } catch (e) {
      AppLogger.warn('NotificationService.initialSubscriberId', e);
      return null;
    }
  }

  static void _handleOpenedMessage(RemoteMessage message) {
    final subscriberId = subscriberIdFrom(message.data);
    if (subscriberId != null) _onTap?.call(subscriberId);
  }

  static void _onLocalNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final subscriberId = subscriberIdFrom(data);
      if (subscriberId != null) _onTap?.call(subscriberId);
    } catch (e) {
      AppLogger.warn('NotificationService: bad notification payload', e);
    }
  }

  /// بتطلّع `subscriberId` من حمولة الإشعار.
  ///
  /// عامة عن قصد: هي عقد بين الـ edge function (يلي بتبعت
  /// `data: { subscriberId, type }`) وبين التطبيق. أي اختلاف بالمفتاح
  /// بيكسر فتح ملف العميل من الإشعار بصمت، فبدها اختبار.
  @visibleForTesting
  static String? subscriberIdFrom(Map<String, dynamic>? data) {
    final value = data?[_subscriberIdKey]?.toString();
    return (value == null || value.isEmpty) ? null : value;
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final channel = _channel;

    try {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: androidIcon,
            color: AppColors.primary,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        // منمرّر الـ data عشان الضغط على الإشعار يفتح ملف العميل.
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      AppLogger.warn('NotificationService: failed to show notification', e);
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      AppLogger.warn('NotificationService.getToken', e);
      return null;
    }
  }
}
