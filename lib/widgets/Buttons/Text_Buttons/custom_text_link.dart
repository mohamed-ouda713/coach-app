import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class CustomTextLink extends StatelessWidget {
  const CustomTextLink({
    super.key,
    required this.color,
    required this.title,
    this.icon,
    this.onPressed,
  });
  final Color color;
  final String title;
  final IconData? icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, color: color),
          Text(title,
              style: AppTextStyles.buttonM.copyWith(
                color: effectiveColor, 
              ),),
        ],
      ),
    );
  }
}
