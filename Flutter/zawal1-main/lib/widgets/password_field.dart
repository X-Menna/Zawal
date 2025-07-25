import 'package:flutter/material.dart';
import 'package:zawal/constants/app_colors.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isVisible;
  final VoidCallback onVisibilityToggle;
  final String? Function(String?) validator;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.isVisible,
    required this.onVisibilityToggle,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      keyboardType: TextInputType.visiblePassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: AppColors.grey.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onVisibilityToggle,
        ),
      ),
    );
  }
}
