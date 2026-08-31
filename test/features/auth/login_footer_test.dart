import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/localization/app_locale.dart';
import 'package:glow_up/core/theme/app_theme.dart';
import 'package:glow_up/features/auth/screens/login/widgets/login_footer.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() => AppLocale.current = AppLocale.arabic);

  Future<void> pumpFooter(WidgetTester tester, {bool isLoading = false}) async {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder:
              (context, state) => Scaffold(
                body: SingleChildScrollView(
                  child: LoginFooter(
                    onLoginPressed: () {},
                    isLoading: isLoading,
                  ),
                ),
              ),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const Scaffold(body: Text('SIGNUP')),
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
  }

  testWidgets('the sign-up link navigates', (tester) async {
    await pumpFooter(tester);

    await tester.tap(find.text(AppStrings.signUpLink));
    await tester.pumpAndSettle();

    expect(find.text('SIGNUP'), findsOneWidget);
  });

  testWidgets('footer text uses readable colours on the light card', (
    tester,
  ) async {
    await pumpFooter(tester);

    // البطاقة بيضا — لازم النص يكون غامق بما يكفي للقراءة. لا اللون
    // البنفسجي القديم ولا AppColors.primary بينفعوا هون (2.77:1)،
    // فالرابط بياخد لونه من appColors.link.
    final link = tester.widget<Text>(find.text(AppStrings.signUpLink));
    final luminance = link.style!.color!.computeLuminance();

    expect(
      luminance,
      lessThan(0.5),
      reason: 'link text must be dark enough to read on a white card',
    );
  });
}
