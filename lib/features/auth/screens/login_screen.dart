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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1️⃣ خلفية الجزء العلوي
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFF0088DD),
          ),

          // الهيدر واللوجو
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AppAvatar(name: AppStrings.appName),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.appName, // "كوتش برو"
                  style: AppTextStyles.display.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.tagline, // "إدارة عملائك باحترافية"
                  style: AppTextStyles.bodyM.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),

          // 2️⃣ الحاوية السفلى (Sheet)
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
                        AppStrings.loginWelcomeBack, // "مرحباً بعودتك"
                        style: AppTextStyles.h1.copyWith(
                          color: AppColorsDark.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppStrings
                            .loginSignInToContinue, // "سجّلي دخولك للمتابعة"
                        style: AppTextStyles.bodyM.copyWith(
                          color: AppColorsDark.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // حقل البريد الإلكتروني
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

                      // حقل كلمة المرور
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
                      const SizedBox(height: AppSpacing.xs),

                      // نسيت كلمة المرور؟
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextLink(
                            textButton: '',
                            title:
                                AppStrings
                                    .loginForgotPassword, // "نسيت كلمة المرور؟"
                            textColor: AppColorsDark.info,
                            onPressed: () {
                              // الانتقال لشاشة نسيت كلمة المرور (F11)
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // زر تسجيل الدخول
                      PrimaryButton(
                        title: AppStrings.loginCta, // "تسجيل الدخول"
                        onTap: () {},
                        backgroundColor: AppColors.primary,
                        textColor: AppColorsDark.textPrimary,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // فاصل (أو)
                      const OrDivider(color: AppColorsDark.textPrimary),
                      const SizedBox(height: AppSpacing.xl),

                      // الرابط السفلي
                      CustomTextLink(
                        textButton:
                            AppStrings.loginNoAccount, // "ليس لديك حساب؟"
                        textButtonColor: AppColorsDark.textSecondary,
                        title: AppStrings.loginContactUs, // "تواصلي معنا"
                        textColor: AppColorsDark.info,
                        onPressed: () {
                          // الانتقال لشاشة التواصل أو الدعم
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
