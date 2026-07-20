import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppFieldError extends StatelessWidget {
  const AppFieldError({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final danger = isDark ? AppColorsDark.danger : AppColorsLight.danger;

    return Padding(
      // ✅ تحسين: استخدام EdgeInsetsDirectional ليدعم الـ RTL والـ LTR تلقائياً دون جمود
      padding: const EdgeInsetsDirectional.only(
        top: AppSpacing.xs, 
        start: AppSpacing.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تحسين بصري: تغليف الأيقونة بـ Padding علوي خفيف لضبط محاذاتها مع أول سطر من النص الطويل
          Padding(
            padding: const EdgeInsets.only(top: 1.5),
            child: Icon(
              Icons.error_outline_rounded, 
              size: AppSizes.iconXs, 
              color: danger,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              message!, 
              style: AppTextStyles.caption.copyWith(color: danger),
            ),
          ),
        ],
      ),
    );
  }
}