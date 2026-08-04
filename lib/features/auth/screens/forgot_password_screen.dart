import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../routing/app_router.dart';

/// شاشة نسيت كلمة المرور (F11) — إدخال البريد وطلب رابط الاستعادة.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.forgotPasswordTitle)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetEmailSent) {
            context.push(
              AppRoutes.passwordResetSent,
              extra: _emailController.text,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.forgotPasswordEnterEmailInstructions,
                  style: AppTextStyles.bodyM,
                ),
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: AppStrings.loginEmailLabel,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () => context.read<AuthCubit>().resetPassword(
                            _emailController.text,
                          ),
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            AppStrings.forgotPasswordSendResetLinkCta,
                          ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text(AppStrings.forgotPasswordBackToLogin),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
