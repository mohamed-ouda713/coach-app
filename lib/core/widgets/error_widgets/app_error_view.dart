import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// نبرة العرض — خطأ (أحمر) أو حالة فاضية محايدة.
enum AppErrorViewTone { error, empty }

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel,
    this.icon = Icons.error_outline_rounded,
    this.tone = AppErrorViewTone.error,
  });

  final String message;

  final VoidCallback? onRetry;

  final String? retryLabel;
  final IconData icon;

  /// نفس الودجت بتستخدم لحالتين مختلفتين: خطأ حقيقي، و"ما في نتائج".
  /// الأحمر مناسب للأول بس — بحالة القائمة الفاضية بيوحي إنه صار خطأ
  /// وما في خطأ.
  final AppErrorViewTone tone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    final isError = tone == AppErrorViewTone.error;
    final iconBg = isError ? appColors.dangerBg : appColors.bgSubtle;
    final iconColor = isError ? colorScheme.error : appColors.textTertiary;
    final messageColor =
        isError ? colorScheme.onSurface : appColors.textSecondary;

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
                color: iconBg,
                borderRadius: BorderRadius.circular(AppRadius.iconCircleXl),
              ),
              child: Icon(icon, size: AppSizes.iconDisplay, color: iconColor),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(color: messageColor),
            ),

            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 160, maxWidth: 240),
                child: SizedBox(
                  height: AppSizes.buttonHeightSm,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.primarySoftBg,
                      foregroundColor: appColors.onPrimarySoftBg,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                    ),
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: AppSizes.icon,
                    ),
                    label: Text(
                      retryLabel ?? AppStrings.errorViewRetry,
                      style: AppTextStyles.buttonM,
                    ),
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
