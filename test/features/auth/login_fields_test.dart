import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/localization/app_locale.dart';
import 'package:glow_up/core/theme/app_theme.dart';
import 'package:glow_up/features/auth/screens/login/widgets/login_fields.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';

/// شاشة الدخول بتحط الحقول جوّا Stack + Positioned + SingleChildScrollView،
/// فمنعيد نفس البنية هون: أي مشكلة hit-testing من التداخل هاد بتظهر
/// بالاختبار بدل ما نكتشفها على الجهاز.
void main() {
  setUp(() => AppLocale.current = AppLocale.arabic);

  Future<GoRouter> pumpLoginFields(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder:
              (context, state) => Scaffold(
                body: Stack(
                  children: [
                    Container(color: Colors.blue),
                    Stack(
                      children: [
                        Positioned(
                          top: 200,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ColoredBox(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: LoginFields(
                                emailController: TextEditingController(),
                                passwordController: TextEditingController(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const Scaffold(body: Text('FORGOT')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light,
        locale: AppLocale.arabic,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('the forgot-password link navigates', (tester) async {
    await pumpLoginFields(tester);

    expect(find.text(AppStrings.loginForgotPassword), findsOneWidget);

    await tester.tap(find.text(AppStrings.loginForgotPassword));
    await tester.pumpAndSettle();

    expect(
      find.text('FORGOT'),
      findsOneWidget,
      reason: 'tapping the link should push the forgot-password route',
    );
  });

  testWidgets('the subtitle aligns with the fields, not centred', (
    tester,
  ) async {
    await pumpLoginFields(tester);

    final subtitle = tester.getRect(
      find.text(AppStrings.loginSignInToContinue),
    );
    final field = tester.getRect(find.byType(TextField).first);

    // بالـ RTL الحافة اليمنى هي بداية السطر — لو كانت المحاذاة بالنص
    // (السلوك الافتراضي للـ Column) بتطلع الحافة اليمنى للنص أصغر من
    // حافة الحقل.
    expect(
      subtitle.right,
      closeTo(field.right, 1),
      reason: 'subtitle should start where the fields start, not be centred',
    );
  });

  testWidgets('email field forces LTR so the caret lands after the text', (
    tester,
  ) async {
    await pumpLoginFields(tester);

    final emailField = tester.widget<TextField>(
      find
          .descendant(
            of: find.ancestor(
              of: find.text(AppStrings.loginEmailLabel).first,
              matching: find.byType(Column),
            ),
            matching: find.byType(TextField),
          )
          .first,
    );

    expect(emailField.textDirection, TextDirection.ltr);
  });
}
