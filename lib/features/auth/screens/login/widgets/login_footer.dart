import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/buttons/primary_button.dart';
import 'package:glow_up/core/widgets/buttons/custom_text_link.dart';
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
          title: AppStrings.loginCta,
          onTap: onLoginPressed,
          isLoading: isLoading,
          backgroundColor: AppColors.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
        ),
        const SizedBox(height: AppSpacing.xl),

        // فاصل (أو)
        const OrDivider(),
        const SizedBox(height: AppSpacing.xl),

        // الرابط السفلي — اللون من `appColors.link` مش من AppColors.primary
        // مباشرة: الأزرق الفاتح تباينه على أبيض 2.77:1 وهو غير مقروء.
        CustomTextLink(
          textButton: AppStrings.loginNoAccount,
          textButtonColor: context.appColors.textSecondary,
          title: AppStrings.signUpLink,
          textColor: context.appColors.link,
          underline: true,
          onPressed: () {
            context.go(AppRoutes.signup);
          },
        ),
      ],
    );
  }
}
