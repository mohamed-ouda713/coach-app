import 'package:flutter/material.dart';

class CusttemTextForm extends StatelessWidget {
  const CusttemTextForm({
    super.key,
    required this.TitelTexst,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
  });
  final String TitelTexst;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              TitelTexst,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            labelText: labelText,
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
