import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.icon,
    this.textColor,
    this.height = AppSizes.buttonHeightMd,
    this.isLoading = false,
  });
  final String title;
  final void Function()? onTap;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? textColor;
  final double height;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading ? null : onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.cardLg),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: AppSizes.icon,
                  height: AppSizes.icon,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: textColor, size: AppSizes.icon),
                      const SizedBox(width: AppSpacing.smMd),
                    ],
                    Text(
                      title,
                      style: AppTextStyles.buttonL.copyWith(color: textColor),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
