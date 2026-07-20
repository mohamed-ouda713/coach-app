import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SerchWidget extends StatelessWidget {
  const SerchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن عميل ...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
