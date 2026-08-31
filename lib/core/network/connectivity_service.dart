import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/app_logger.dart';

/// بتراقب حالة الاتصال بالخلفية وبتحتفظ بآخر قيمة معروفة بمتغير عادي.
///
/// السبب إنها cached ومش async: [ExceptionMapper] بتشتغل جوّا `catch`
/// متزامن، فما بتقدر تعمل `await` على فحص الشبكة. بدون هالمعلومة كل
/// خطأ شبكة بيطلع برسالة "لا يوجد اتصال" حتى لو النت شغال والمشكلة
/// بالخادم — وهاد بيخلي الرسالة مضللة بدل ما تكون مفيدة.
class ConnectivityService {
  ConnectivityService._();

  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// بنبلّش بـ true بشكل متفائل — لو ما قدرنا نفحص، ما منتهم الشبكة.
  static bool _isOnline = true;

  static bool get isOnline => _isOnline;

  static Future<void> initialize() async {
    try {
      _isOnline = _hasConnection(await _connectivity.checkConnectivity());
      _subscription ??= _connectivity.onConnectivityChanged.listen(
        (results) => _isOnline = _hasConnection(results),
        onError: (Object error) => AppLogger.warn('connectivity stream', error),
      );
    } catch (e) {
      // فشل فحص الشبكة نفسه ما بيوقف التطبيق — بنضل على القيمة المتفائلة.
      AppLogger.warn('ConnectivityService.initialize', e);
    }
  }

  static bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// للاختبارات فقط.
  static void debugSetOnline(bool value) => _isOnline = value;

  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
