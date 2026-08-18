import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      validator: validator,
      enabled: enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null
            ? null
            : Icon(icon, size: 20, color: AppColors.gray400),
      ),
    );
  }
}
