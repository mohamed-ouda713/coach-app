import 'package:flutter/widgets.dart';

class CustomTextLink extends StatelessWidget {
  const CustomTextLink({
    super.key,
    required this.color,
    required this.Titel,
    this.icon,
    this.onPressed,
  });
  final Color color;
  final String Titel;
  final IconData? icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, color: color),
          Text(
            Titel,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
