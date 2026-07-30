import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/widgets/Buttons/Primary_Buttons/primary_Buttons.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/custom_text_link.dart';
import 'package:glow_up/core/widgets/layout/or_divider.dart';
import 'package:glow_up/core/widgets/media/app_avatar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFF0088DD),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AppAvatar(name: AppStrings.appName),

                Text(
                  AppStrings.appName,
                  style: AppTextStyles.display.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.signUpWelcomeLetsStart,
                  style: AppTextStyles.bodyM.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),

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
                    horizontal: AppSpacing.screenPadding, // 26px مسافة جانبية
                    vertical: AppSpacing.xxl,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppStrings.signUpScreenTitle,
                        style: AppTextStyles.h1.copyWith(
                          color: AppColorsDark.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppStrings.signUpEnterDataToStart,
                        style: AppTextStyles.bodyM.copyWith(
                          color: AppColorsDark.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      CustomTextFormField(
                        suffixIcon: const Icon(
                          Icons.person,
                          size: AppSizes.icon,
                          color: AppColorsDark.textSecondary,
                        ),
                        fillColor: Colors.transparent,
                        title: AppStrings.addClientFullNameLabel,
                        hintText: AppStrings.addClientFullNameLabel,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      CustomTextFormField(
                        suffixIcon: const Icon(
                          Icons.email_outlined,
                          size: AppSizes.icon,
                          color: AppColorsDark.textSecondary,
                        ),
                        fillColor: Colors.transparent,
                        title: AppStrings.loginEmailLabel,
                        hintText: AppStrings.loginEmailLabel,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      CustomTextFormField(
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
                      const SizedBox(height: AppSpacing.xl),
                      PrimaryButton(
                        title: AppStrings.createAccountCta,
                        onTap: () {},
                        backgroundColor: AppColors.primary,
                        textColor: AppColorsDark.textPrimary,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      OrDivider(),
                      const SizedBox(height: AppSpacing.xl),
                      CustomTextLink(
                        textButton:
                            AppStrings
                                .loginCta, // 👈 استبدال النص المباشر بالثابت
                        textButtonColor: AppColorsDark.info,
                        title: AppStrings.forgotPasswordRecoverPassword,
                        textColor: AppColorsDark.textSecondary,
                        onPressed: () {
                          // كود استعادة كلمة المرور
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
