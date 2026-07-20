import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart'; // تأكد من مسار الـ Spacing الصحيح في مشروعك
import '../../constants/app_borders.dart';
import '../../constants/app_radius.dart';
import '../../theme/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TODO: نستبدل هالسطرين بـ Theme.of(context).colorScheme.outline و
    // onSurfaceVariant لما تنضاف هالحقول لـ AppTheme.
    final Color borderColor = isDark ? AppColorsDark.border : AppColorsLight.border;
    final Color textColor = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final Color surfaceColor = isDark ? AppColorsDark.bgCard : AppColorsLight.bgCard;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, 
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : surfaceColor,
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