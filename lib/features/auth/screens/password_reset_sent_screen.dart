import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../routing/app_router.dart';

/// شاشة تأكيد إرسال رابط الاستعادة (F12).
class PasswordResetSentScreen extends StatelessWidget {
  const PasswordResetSentScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.forgotPasswordLinkSentTitle)),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.forgotPasswordEmailSentHeading,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: AppSpacing.smMd),
              Text(
                AppStrings.forgotPasswordCheckEmailInstructions,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyM,
              ),
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: () {},
                child: const Text(AppStrings.forgotPasswordOpenEmailCta),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.forgotPasswordDidNotReceiveEmail,
                    style: AppTextStyles.bodyS,
                  ),
                  TextButton(
                    onPressed:
                        () => context.read<AuthCubit>().resetPassword(email),
                    child: const Text(AppStrings.forgotPasswordResend),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text(AppStrings.forgotPasswordBackToLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
