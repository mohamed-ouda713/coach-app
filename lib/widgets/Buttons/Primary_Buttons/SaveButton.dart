import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Savebutton extends StatelessWidget {
  const Savebutton({
    super.key,
    required this.title,
    required this.ContainerColor,
  });
  final String title;
  final Color ContainerColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: ContainerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
