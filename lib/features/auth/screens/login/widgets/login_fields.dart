import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/custom_text_link.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_card.dart';
import 'package:glow_up/features/auth/helper/app_validators.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class LoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final String? errorMessage;
  const LoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.loginSignInToContinue,
          style: AppTextStyles.bodyM.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          AppErrorCard(message: errorMessage),
        ],
        const SizedBox(height: AppSpacing.lg),

        // حقل البريد الإلكتروني
        CustomTextFormField(
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icon(
            Icons.email_outlined,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          title: AppStrings.loginEmailLabel,
          hintText: AppStrings.loginEmailLabel,
          controller: emailController,
          validator: AppValidators.validateEmail,
        ),
        const SizedBox(height: AppSpacing.lg),

        // حقل كلمة المرور
        CustomTextFormField(
          obscureText: true,
          suffixIcon: Icon(
            Icons.lock_outline,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          title: AppStrings.loginPasswordLabel,
          hintText: AppStrings.loginPasswordLabel,
          controller: passwordController,
          validator: AppValidators.validatePassword,
        ),
        const SizedBox(height: AppSpacing.xs),

        // نسيت كلمة المرور؟
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextLink(
              textButton: '',
              title: AppStrings.loginForgotPassword,
              textColor: context.appColors.info,
              onPressed: () => context.push(AppRoutes.forgotPassword),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
