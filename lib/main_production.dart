// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glow_up/features/financial/cubit/financial_cubit.dart';
import 'package:glow_up/features/financial/data/financial_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_strings.dart';
import 'core/constants/supabase_constants.dart';
import 'core/localization/app_locale.dart';
import 'core/localization/cubit/locale_cubit.dart';
import 'core/network/connectivity_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/notifications/services/notification_service.dart';
import 'firebase_options.dart';
import 'routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');

  // شاشات التطبيق مبنية على نسب من ارتفاع الشاشة (مثلاً بطاقة الدخول
  // بتبلّش عند 32% من الارتفاع). بالوضع الأفقي الارتفاع بينزل تحت
  // النص، فبطاقة الدخول بتغطي اسم التطبيق والوصف. التصميم أصلاً
  // عمودي — فمنثبّته بدل ما نترك تخطيط مكسور يظهر بالدوران.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // إعداد قناة الإشعارات والمستمعين فقط — **بدون** طلب الإذن. طلب الإذن
  // بينتقل لما يسجّل المدرب دخوله (شوف AuthCubit)، لأن iOS بيعطي فرصة
  // وحدة بس لهاد الـ prompt: لو ظهر فوق شاشة البداية قبل ما يعرف
  // المستخدم شو التطبيق أصلاً، الرفض بيصير دائم وبتضيع الميزة كلها.
  await NotificationService.initialize();

  // مراقبة الاتصال بالخلفية — ExceptionMapper بتقرأ منها عشان تفرّق
  // بين انقطاع النت ومشكلة بالخادم.
  await ConnectivityService.initialize();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthCubit? _authCubit;
  GoRouter? _router;

  /// الراوتر بينتبنى مرة وحدة بس.
  ///
  /// كان بينتبنى جوّا build، يعني كل إعادة بناء لـ MyApp كانت تعمل
  /// GoRouter جديد — بتضيع حالة التنقّل، وبيتسجّل مستمع ضغط الإشعار
  /// من جديد، وبينعاد فحص إشعار الإقلاع فبينفتح ملف العميل مرتين.
  GoRouter _routerFor(AuthCubit authCubit) {
    if (_router != null && identical(_authCubit, authCubit)) return _router!;
    _authCubit = authCubit;
    return _router = buildAppRouter(authCubit);
  }

  @override
  Widget build(BuildContext context) {
    final supabaseClient = Supabase.instance.client;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthRepository(supabaseClient))),
        BlocProvider(
          create: (_) => FinancialCubit(FinancialRepository(supabaseClient)),
        ),
        BlocProvider(create: (_) => ThemeCubit(widget.prefs)),
        BlocProvider(create: (_) => LocaleCubit(widget.prefs)),
      ],
      child: Builder(
        builder: (context) {
          final router = _routerFor(context.read<AuthCubit>());
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return MaterialApp.router(
                    title: AppStrings.appName,
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.light,
                    darkTheme: AppTheme.dark,
                    themeMode: themeMode,
                    locale: locale,
                    supportedLocales: AppLocale.supported,
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    routerConfig: router,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
