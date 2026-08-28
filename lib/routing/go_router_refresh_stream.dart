import 'dart:async';

import 'package:flutter/foundation.dart';

/// يحوّل أي Stream (زي AuthCubit.stream) لـ Listenable يقدر GoRouter
/// يسمعله عبر refreshListenable، عشان يعيد فحص redirect تلقائيًا
/// كل ما تتغير حالة تسجيل الدخول.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
