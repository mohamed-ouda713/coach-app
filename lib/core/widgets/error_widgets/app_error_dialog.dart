import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

import '../../constants/app_borders.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class AppErrorDialog extends StatelessWidget {
  const AppErrorDialog({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.error_outline_rounded,
    this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
  });

  final String? title;
  final String message;
  final IconData icon;
  final String? confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;

  static Future<bool?> show(
    BuildContext context, {
    required String message,
    String? title,
    IconData icon = Icons.error_outline_rounded,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: cancelLabel == null,
      builder:
          (_) => AppErrorDialog(
            title: title,
            message: message,
            icon: icon,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            isDestructive: isDestructive,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    final Color headerIconColor =
        isDestructive ? colorScheme.error : colorScheme.primary;
    final Color headerBgColor = isDestructive
        ? appColors.dangerBg
        : colorScheme.primary.withOpacity(0.12);

    final hasCancel = cancelLabel != null;

    return Dialog(
      backgroundColor: colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardLg),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxxl,
          AppSpacing.xxxl,
          AppSpacing.xxxl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.avatarMd,
              height: AppSizes.avatarMd,
              decoration: BoxDecoration(
                color: headerBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppSizes.iconXxl, color: headerIconColor),
            ),
            const SizedBox(height: AppSpacing.lgAlt),
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.smMd),
                    ],
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyM.copyWith(
                        color: appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              children: [
                if (hasCancel) ...[
                  Expanded(
                    child: SizedBox(
                      height: AppSizes.buttonHeightSm,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: appColors.border,
                            width: AppBorders.regular,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.card),
                          ),
                        ),
                        child: Text(
                          cancelLabel!,
                          style: AppTextStyles.buttonM.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.smMd),
                ],
                Expanded(
                  child: SizedBox(
                    height: AppSizes.buttonHeightSm,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDestructive ? colorScheme.error : colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.card),
                        ),
                      ),
                      child: Text(
                        confirmLabel ?? AppStrings.dialogConfirmOk,
                        style: AppTextStyles.buttonM,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}