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

class SignupFooter extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onSignUpPressed;
  final bool isLoading;
  const SignupFooter({
    super.key,
    this.onSignUpPressed,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          title: AppStrings.createAccountCta,
          onTap: onSignUpPressed,
          isLoading: isLoading,
          backgroundColor: AppColors.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
        ),
        const SizedBox(height: AppSpacing.xl),

        const OrDivider(),
        const SizedBox(height: AppSpacing.xl),

        // 5️⃣ رابط الانتقال لصفحة الدخول
        CustomTextLink(
          title: AppStrings.loginCta,
          textColor: context.appColors.link,
          underline: true,
          onPressed: () {
            if (onPressed != null) {
              onPressed!();
            } else {
              context.go(AppRoutes.login);
            }
          },
        ),
      ],
    );
  }
}
