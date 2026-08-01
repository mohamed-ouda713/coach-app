import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_borders.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required this.title,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
  });
  final String title;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final colors = context.appColors;
    final theme = Theme.of(context);
    final textSecondaryColor = theme.hintColor;
    final borderColor = theme.dividerColor;
    final primaryColor = theme.colorScheme.primary;
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyM.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xl,
              ),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(width: AppBorders.regular),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
