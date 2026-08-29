import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/inputs/custom_text_form_field.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_card.dart';
import 'package:glow_up/features/auth/helper/app_validators.dart';

class SignupFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool enabled;
  final String? errorMessage;
  const SignupFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.enabled,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        if (errorMessage != null) ...[
          AppErrorCard(message: errorMessage),
          const SizedBox(height: AppSpacing.lg),
        ],

        // 1️⃣ حقل الاسم الكامل
        CustomTextFormField(
          controller: nameController,
          validator: AppValidators.validateName,
          suffixIcon: Icon(
            Icons.person,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          title: AppStrings.addClientFullNameLabel,
          hintText: AppStrings.addClientFullNameLabel,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 2️⃣ حقل البريد الإلكتروني
        CustomTextFormField(
          controller: emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: AppValidators.validateEmail,
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icon(
            Icons.email_outlined,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          title: AppStrings.loginEmailLabel,
          hintText: AppStrings.loginEmailLabel,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 3️⃣ حقل كلمة المرور
        CustomTextFormField(
          controller: passwordController,
          obscureText: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: AppValidators.validatePassword,

          helperText: AppStrings.passwordHint,
          prefixIcon: Icon(
            Icons.visibility_outlined,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          suffixIcon: Icon(
            Icons.lock_outline,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          title: AppStrings.loginPasswordLabel,
          hintText: AppStrings.loginPasswordLabel,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
