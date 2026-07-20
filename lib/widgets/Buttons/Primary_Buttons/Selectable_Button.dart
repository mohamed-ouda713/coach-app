import 'package:flutter/material.dart';

class SelectedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;

  const SelectedButton({
    super.key,
    required this.title,
    this.onTap,
    this.borderColor = const Color(0xFF0082C8),
    this.textColor = const Color(0xFF0082C8),
    this.backgroundColor = const Color(0xFF0B1E2D),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
