import 'package:flutter/material.dart';
import 'package:glow_up/core/screens/home_page.dart';
import 'package:glow_up/features/auth/screens/login/login_screen.dart';
import 'package:glow_up/features/auth/screens/signUp/signUp_screen.dart';
import 'package:go_router/go_router.dart';

/// مثال توضيحي  — مسار واحد لشاشة تسجيل الدخول .
/// كل feature لاحقًا بتضيف مساراتها هون بنفس الطريقة.
class AppRoutes {
  AppRoutes._();
  static const signup = '/signup';
  static const login = '/login';
  static const String home = '/home';
  // static const clientsList = '/clients';
  // static const clientProfile = '/clients/:id';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(), // 👈 شاشة تسجيل الدخول
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    // GoRoute(
    //   path: AppRoutes.clientsList,
    //   builder: (context, state) => const ClientsListScreen(),
    // ),
    // GoRoute(
    //   path: AppRoutes.clientProfile,
    //   builder: (context, state) {
    //     final clientId = state.pathParameters['id']!;
    //     return ClientProfileScreen(clientId: clientId);
    //   },
    // ),
  ],
);

/// مكانها مؤقت — بيتشال لما شاشة تسجيل الدخول الحقيقية تنكتب بـ
/// features/auth/screens/login_screen.dart
class _LoginScreenPlaceholder extends StatelessWidget {
  const _LoginScreenPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Login screen')));
  }
}
