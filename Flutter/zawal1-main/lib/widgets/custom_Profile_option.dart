import 'package:flutter/material.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/constants/app_textstyles.dart';

class CustomProfileOption extends StatelessWidget {
  const CustomProfileOption({
    super.key,

    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24.sp),
      title: Text(title, style: AppTextStyles.body),
      //trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primary),
      onTap: onTap,
    );
  }
}
