import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/widgets/status/app_success_snackbar.dart';
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          AppSuccessSnackbar.show(context, AppStrings.loginSuccessMessage);
          context.go(AppRoutes.home);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final errorMessage = state is AuthError ? state.message : null;
        return Stack(
          children: [
            Positioned(
              top:
                  MediaQuery.of(context).size.height *
                  AppSizes.authCardTopFraction,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العنوان والوصف
                        Text(
                          AppStrings.loginWelcomeBack,
                          style: AppTextStyles.h1.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        LoginFields(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          errorMessage: errorMessage,
                        ),

                        LoginFooter(
                          isLoading: isLoading,
                          onLoginPressed: () {
                            context.read<AuthCubit>().signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
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
        );
      },
    );
  }
}
