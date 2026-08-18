import 'package:flutter/material.dart';

class ButtonSpinner extends StatelessWidget {
  const ButtonSpinner({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}
