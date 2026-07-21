import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = AppStrings.errorViewRetry,
    this.icon = Icons.error_outline_rounded,
  });

 
  final String message;

  final VoidCallback? onRetry;

  final String retryLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.avatarLogo,
              height: AppSizes.avatarLogo,
              decoration: BoxDecoration(
                color: appColors.dangerBg,
                borderRadius: BorderRadius.circular(AppRadius.iconCircleXl),
              ),
              child: Icon(icon, size: AppSizes.iconDisplay, color: colorScheme.error),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(color: colorScheme.onSurface),
            ),
            
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 160, 
                  maxWidth: 240, 
                ),
                child: SizedBox(
                  height: AppSizes.buttonHeightSm,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.primarySoftBg,
                      foregroundColor: appColors.onPrimarySoftBg,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: AppSizes.icon),
                    label: Text(retryLabel, style: AppTextStyles.buttonM),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}