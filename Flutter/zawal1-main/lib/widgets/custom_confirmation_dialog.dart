import 'package:flutter/material.dart';
import 'package:zawal/constants/app_colors.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancle;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: isDark ? Colors.black : Colors.white,
      title: Text(
        title,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      content: Text(
        content,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),

      actions: [
        TextButton(
          onPressed: onCancle,
          child: Text(cancelText, style: TextStyle(color: AppColors.primary)),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(confirmText, style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}
