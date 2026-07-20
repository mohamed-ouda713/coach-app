import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddDate extends StatelessWidget {
  const AddDate({
    super.key,
    required this.Titel,
    required this.labelText,
    this.icon,
  });
  final String Titel;
  final String labelText;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF0B1E2D).withValues(alpha: 0.9),
            border: Border.all(color: const Color(0xFF0082C8), width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(Titel, style: TextStyle(color: Color(0xFF0082C8))),
                const SizedBox(width: 8),
                Icon(icon, color: Color(0xFF0082C8)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
