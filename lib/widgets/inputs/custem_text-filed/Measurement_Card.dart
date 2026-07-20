import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MeasurementCard extends StatelessWidget {
  const MeasurementCard({
    super.key,
    required this.Titel,
    required this.labelText,
    this.icon,
    required this.SubTitel,
  });
  final String Titel;
  final String SubTitel;
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF0B1E2D),
            border: Border.all(color: const Color(0xFF0082C8), width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Column(
              children: [
                Text(
                  Titel,
                  style: TextStyle(color: Color(0xFF0082C8), fontSize: 30),
                ),
                Text(
                  SubTitel,
                  style: TextStyle(color: Color(0xFF0082C8), fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
//Selected
//non