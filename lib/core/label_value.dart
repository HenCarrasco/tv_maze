import 'package:flutter/material.dart';

class LabelValue extends StatelessWidget {
  LabelValue(
      {@required this.label,
      this.value,
      this.labelStyle:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      this.valueStyle: const TextStyle(color: Colors.black),
      this.textAlign,
      this.child});

  final String label;
  final String value;
  final TextAlign textAlign;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        SizedBox(height: 8),
        child != null
            ? child
            : Text(
                value,
                textAlign: textAlign,
                style: valueStyle,
              )
      ],
    );
  }
}
