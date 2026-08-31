import 'package:flutter/foundation.dart';

/// نقطة تسجيل واحدة بدل خليط `print` و `debugPrint` و try/catch صامتة.
///
/// كلها بتنطفي تلقائيًا بالـ release (debugPrint بيصير no-op بالـ profile
/// والـ release)، وبنفس الوقت بتعطينا مكان واحد نوصل منه لـ Crashlytics
/// أو Sentry لاحقًا بدون ما نلاحق كل `catch` بالمشروع.
class AppLogger {
  AppLogger._();

  /// خطأ صار وما قدرنا نعالجه — بينعرض للمستخدم كمان عبر ExceptionMapper.
  static void error(String context, Object error, [StackTrace? stackTrace]) {
    _log('ERROR', context, error);
    if (stackTrace != null && kDebugMode) {
      debugPrint(stackTrace.toString());
    }
  }

  /// خطأ ابتلعناه عن قصد لأنه ما بيأثر على المستخدم (تحديث badge، FCM token).
  static void warn(String context, Object error) {
    _log('WARN', context, error);
  }

  /// معلومة تتبّع بالتطوير فقط.
  static void info(String context, String message) {
    _log('INFO', context, message);
  }

  static void _log(String level, String context, Object detail) {
    if (kDebugMode) {
      debugPrint('[$level] $context: $detail');
    }
  }
}
