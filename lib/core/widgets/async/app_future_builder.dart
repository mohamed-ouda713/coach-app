// lib/core/widgets/async/app_future_builder.dart

import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_view.dart';

/// يغلّف نمط "جلب عنصر واحد عبر Future" المتكرر بأكثر من شاشة
/// (مثلاً: جلب عميلة بالـ id بشاشة الملف الشخصي وشاشة التعديل):
/// - Spinner لحد ما ينتهي الـ Future.
/// - [AppErrorView] موحّدة لو صار خطأ أو رجعت البيانات فاضية.
/// - [builder] بالبيانات الجاهزة عند النجاح.
///
/// بيلغي الحاجة لتكرار نفس الـ FutureBuilder + الـ ConnectionState
/// check بكل شاشة لحالها.
class AppFutureBuilder<T> extends StatelessWidget {
  const AppFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.errorMessage,
    this.onRetry,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return AppErrorView(
            message: errorMessage ?? AppStrings.defaultErrorMessage,
            onRetry: onRetry,
          );
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}