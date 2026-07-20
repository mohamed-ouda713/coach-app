import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActioniconButton extends StatelessWidget {
  const ActioniconButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.ContainerColor,
    required this.iconColor,
  });
  final IconData icon;
  final void Function()? onPressed;
  final Color ContainerColor;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ContainerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor),
      ),
    );
  }
}
