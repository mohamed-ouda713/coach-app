import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/screens/home_page.dart';
import 'package:glow_up/core/screens/profile_screen.dart';
import 'package:glow_up/features/auth/screens/login/login_screen.dart';
import 'package:glow_up/features/auth/screens/signup/signup_screen.dart';
import 'package:glow_up/features/subscribers/screens/add_subscriber_screen.dart';
import 'package:glow_up/features/subscribers/screens/client_profile_screen.dart';
import 'package:glow_up/features/subscribers/screens/edit_subscriber_screen.dart';
import 'package:glow_up/features/subscribers/screens/subscribers_list_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/cubit/auth_cubit.dart';
import '../features/auth/cubit/auth_state.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/password_reset_sent_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/measurements/cubit/measurements_cubit.dart';
import '../features/measurements/data/measurement_repository.dart';
import '../features/measurements/screens/add_measurement_screen.dart';
import '../features/measurements/screens/client_measurements_screen.dart';
import 'go_router_refresh_stream.dart';

/// كل feature بتضيف مساراتها هون بنفس الطريقة.
class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const passwordResetSent = '/forgot-password/sent';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const profile = '/home/profile';
  static const clientsList = '/clients';
  static const clientProfile = '/clients/:id';
  static const addSubscriber = '/clients/add';
  static const editSubscriber = '/clients/:id/edit';
  static const addMeasurement = '/subscribers/:subscriberId/measurements/add';
  static const addMeasurementPickClient = '/measurements/add';
  static const clientMeasurements = '/subscribers/:subscriberId/measurements';
}

final _authRoutes = {
  AppRoutes.login,
  AppRoutes.signup,
  AppRoutes.forgotPassword,
  AppRoutes.passwordResetSent,
  AppRoutes.resetPassword,
};

MeasurementsCubit _measurementsCubit() =>
    MeasurementsCubit(MeasurementRepository(Supabase.instance.client));

String? _redirect(
  BuildContext context,
  GoRouterState state,
  AuthCubit authCubit,
) {
  final authState = authCubit.state;

  // لسا ما تحقّقنا من حالة الجلسة (أول لحظة فتح التطبيق) — لا تعيد التوجيه لحد ما نعرف.
  if (authState is AuthInitial) return null;

  // فتح رابط استعادة كلمة المرور — حوّلها لشاشة تعيين كلمة مرور جديدة
  // بغض النظر وين كانت واقفة، ومنعها من الرجوع لأي شاشة تانية لحد ما تكمل.
  if (authState is AuthPasswordRecovery) {
    return state.matchedLocation == AppRoutes.resetPassword
        ? null
        : AppRoutes.resetPassword;
  }

  final isAuthenticated = authState is AuthAuthenticated;
  final isOnAuthRoute = _authRoutes.contains(state.matchedLocation);

  if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;
  if (isAuthenticated && isOnAuthRoute) return AppRoutes.home;

  return null;
}

/// بتاخد AuthCubit عشان تراقب حالة الجلسة وتعيد فحص redirect تلقائيًا
/// كل ما تتغير (دخول/خروج/انتهاء صلاحية التوكن).
GoRouter buildAppRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) => _redirect(context, state, authCubit),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.passwordResetSent,
        builder:
            (context, state) =>
                PasswordResetSentScreen(email: state.extra as String? ?? ''),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.clientsList,
        builder: (context, state) => const SubscribersListScreen(),
      ),
      GoRoute(
        path: AppRoutes.addSubscriber,
        builder: (context, state) => const AddSubscriberScreen(),
      ),
      GoRoute(
        path: AppRoutes.editSubscriber,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditSubscriberScreen(subscriberId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.clientProfile,
        builder: (context, state) {
          final clientId = state.pathParameters['id']!;
          return ClientProfileScreen(clientId: clientId);
        },
      ),

      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.addMeasurement,
        builder:
            (context, state) => BlocProvider(
              create: (_) => _measurementsCubit(),
              child: AddMeasurementScreen(
                subscriberId: state.pathParameters['subscriberId']!,
                subscriberName: state.extra as String?,
              ),
            ),
      ),
      GoRoute(
        path: AppRoutes.addMeasurementPickClient,
        builder:
            (context, state) => BlocProvider(
              create: (_) => _measurementsCubit(),
              child: const AddMeasurementScreen(),
            ),
      ),
      GoRoute(
        path: AppRoutes.clientMeasurements,
        builder:
            (context, state) => BlocProvider(
              create: (_) => _measurementsCubit(),
              child: ClientMeasurementsScreen(
                subscriberId: state.pathParameters['subscriberId']!,
                subscriberName: state.extra as String? ?? '',
                justAdded: state.uri.queryParameters['added'] == '1',
              ),
            ),
      ),
    ],
  );
}
