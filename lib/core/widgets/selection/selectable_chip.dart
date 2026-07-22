import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/context_extensions.dart'; 
import '../../constants/app_borders.dart';
import '../../constants/app_radius.dart';
import '../../theme/app_text_styles.dart';

/// شريحة اختيار (Selectable Chip) — تُستخدم لاختيار الهدف، البرنامج،
/// أو فلترة قائمة العملاء. بتاخد حالتين: محددة (selected) أو غير محددة.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    final Color borderColor = appColors.border;
    final Color textColor = appColors.textSecondary;
    final Color surfaceColor = colorScheme.surface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, 
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.badge),
          border: isSelected
              ? null
              : Border.all(color: borderColor, width: AppBorders.thin),
        ),
        child: Text(
          label,
          style: AppTextStyles.captionMedium.copyWith(
            color: isSelected ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }
}