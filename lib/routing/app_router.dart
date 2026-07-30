import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/measurements/cubit/measurements_cubit.dart';
import '../features/measurements/data/measurement_repository.dart';
import '../features/measurements/screens/add_measurement_screen.dart';
import '../features/measurements/screens/measurement_history_screen.dart';
import '../features/measurements/screens/overall_progress_screen.dart';

/// كل feature بتضيف مساراتها هون بنفس الطريقة.
class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  // static const clientsList = '/clients';
  // static const clientProfile = '/clients/:id';
  static const addMeasurement = '/subscribers/:subscriberId/measurements/add';
  static const measurementHistory = '/subscribers/:subscriberId/measurements';
  static const overallProgress = '/subscribers/:subscriberId/measurements/progress';
}

MeasurementsCubit _measurementsCubit() =>
    MeasurementsCubit(MeasurementRepository(Supabase.instance.client));

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const _LoginScreenPlaceholder(),
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
    GoRoute(
      path: AppRoutes.addMeasurement,
      builder: (context, state) => BlocProvider(
        create: (_) => _measurementsCubit(),
        child: AddMeasurementScreen(subscriberId: state.pathParameters['subscriberId']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.measurementHistory,
      builder: (context, state) => BlocProvider(
        create: (_) => _measurementsCubit(),
        child: MeasurementHistoryScreen(subscriberId: state.pathParameters['subscriberId']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.overallProgress,
      builder: (context, state) => BlocProvider(
        create: (_) => _measurementsCubit(),
        child: OverallProgressScreen(subscriberId: state.pathParameters['subscriberId']!),
      ),
    ),
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
