import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../helper/app_validators.dart';

/// شاشة تعيين كلمة مرور جديدة — بتفتح بعد ما المستخدم يدوس على رابط
/// الاستعادة يلي وصله بالإيميل (F11 / F12).
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? v) {
    if (v != _passwordController.text) {
      return AppStrings.resetPasswordMismatch;
    }
    return null;
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().updatePassword(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.resetPasswordTitle)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.resetPasswordInstructions,
                    style: AppTextStyles.bodyM,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  CustomTextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: AppValidators.validatePassword,
                    helperText: AppStrings.passwordHint,
                    title: AppStrings.resetPasswordNewPasswordLabel,
                    hintText: AppStrings.resetPasswordNewPasswordLabel,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validateConfirmPassword,
                    title: AppStrings.resetPasswordConfirmPasswordLabel,
                    hintText: AppStrings.resetPasswordConfirmPasswordLabel,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  ElevatedButton(
                    onPressed: isLoading ? null : () => _submit(context),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: AppSizes.icon,
                              height: AppSizes.icon,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                            : Text(AppStrings.resetPasswordSubmitCta),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
