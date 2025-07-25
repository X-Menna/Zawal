import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/constants/app_textstyles.dart';

class CustomProfileEditeTextfield extends StatelessWidget {
  const CustomProfileEditeTextfield({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: AppTextStyles.body),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.grey, fontSize: 14.sp),
            filled: true,
            fillColor: AppColors.grey.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            border: InputBorder.none,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
