import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/widgets/Buttons/Primary_Buttons/primary_Buttons.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/custom_text_link.dart';
import 'package:glow_up/core/widgets/layout/or_divider.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final bool isLoading;
  const LoginFooter({
    super.key,
    required this.onLoginPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          title: isLoading ? 'جاري التحميل...' : AppStrings.loginCta,
          onTap: isLoading ? null : onLoginPressed,
          backgroundColor: AppColors.primary,
          textColor: AppColorsDark.textPrimary,
        ),
        const SizedBox(height: AppSpacing.xl),

        // فاصل (أو)
        const OrDivider(color: AppColorsDark.textPrimary),
        const SizedBox(height: AppSpacing.xl),

        // الرابط السفلي
        CustomTextLink(
          textButton: AppStrings.loginNoAccount,
          textButtonColor: AppColorsDark.textSecondary,
          title: AppStrings.loginContactUs,
          textColor: AppColorsDark.info,
          onPressed: () {
            context.go(AppRoutes.signup);
          },
        ),
      ],
    );
  }
}
