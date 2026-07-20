import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SecondryButtons extends StatelessWidget {
  const SecondryButtons({
    super.key,
    required this.title,
    this.onTap,
    required this.colorContainer,
  });
  final String title;
  final void Function()? onTap;
  final MaterialColor colorContainer;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: colorContainer[350],
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
      ),
    );
  }
}
