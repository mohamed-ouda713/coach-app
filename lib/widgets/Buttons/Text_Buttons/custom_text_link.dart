import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class CustomTextLink extends StatelessWidget {
  const CustomTextLink({
    super.key,
     this.color,
    required this.title,
    this.icon,
    this.onPressed,
  });
  final Color? color;
  final String title;
  final IconData? icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: effectiveColor),
          const SizedBox(width: AppSpacing.xs),
          Text(title,
              style: AppTextStyles.buttonM.copyWith(
                color: effectiveColor, 
              ),),
        ],
      ),
    );
  }
}
