import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/features/auth/cubit/auth_cubit.dart';
import 'package:glow_up/features/auth/cubit/auth_state.dart';
import 'package:glow_up/features/auth/screens/login/widgets/login_fields.dart';
import 'package:glow_up/features/auth/screens/login/widgets/login_footer.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class LoginFormCard extends StatefulWidget {
  const LoginFormCard({super.key});

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تسجيل الدخول بنجاح! 🎉')),
          );
          context.go(AppRoutes.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.financeExpense,
            ),
          );
        }
      },
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColorsDark.bgCard,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.sheet),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.xxl,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // العنوان والوصف
                      Text(
                        AppStrings.loginWelcomeBack,
                        style: AppTextStyles.h1.copyWith(
                          color: AppColorsDark.textPrimary,
                        ),
                      ),
                      LoginFields(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),

                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return LoginFooter(
                            isLoading: state is AuthLoading,
                            onLoginPressed: () {
                              context.read<AuthCubit>().signIn(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
