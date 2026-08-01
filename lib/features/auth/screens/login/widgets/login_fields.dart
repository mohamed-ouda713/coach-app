import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/custom_text_link.dart';

class LoginFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.loginSignInToContinue,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColorsDark.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // حقل البريد الإلكتروني
        CustomTextFormField(
          keyboardType: TextInputType.emailAddress,
          suffixIcon: const Icon(
            Icons.email_outlined,
            size: AppSizes.icon,
            color: AppColorsDark.textSecondary,
          ),
          fillColor: Colors.transparent,
          title: AppStrings.loginEmailLabel,
          hintText: AppStrings.loginEmailLabel,
          controller: emailController,
        ),
        const SizedBox(height: AppSpacing.lg),

        // حقل كلمة المرور
        CustomTextFormField(
          obscureText: true,
          prefixIcon: const Icon(
            Icons.visibility_outlined,
            size: AppSizes.icon,
            color: AppColorsDark.textSecondary,
          ),
          suffixIcon: const Icon(
            Icons.lock_outline,
            size: AppSizes.icon,
            color: AppColorsDark.textSecondary,
          ),
          fillColor: Colors.transparent,
          title: AppStrings.loginPasswordLabel,
          hintText: AppStrings.loginPasswordLabel,
        ),
        const SizedBox(height: AppSpacing.xs),

        // نسيت كلمة المرور؟
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextLink(
              textButton: '',
              title: AppStrings.loginForgotPassword,
              textColor: AppColorsDark.info,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
