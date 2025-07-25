import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset('assets/images/about_bg.png', fit: BoxFit.cover),
          ),

          // Blur overlay
          Container(color: Colors.black.withOpacity(0.4)),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          // Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Zawal',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Discover. Dream. Depart.",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Zawal is more than just a travel app — it's your gateway to the world's hidden gems. Whether you're craving peace, thrill, or cultural richness, Zawal is your guide to unforgettable experiences tailored just for you.",
                          style: TextStyle(
                            fontSize: 15.sp,
                            height: 1.6,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "🌟 Key Features:",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Feature 1
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.explore,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  "Smart destination suggestions based on your vibe.",
                                  style: TextStyle(fontSize: 14.5.sp),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Feature 2
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_border,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  "Like and save the places that speak to your soul.",
                                  style: TextStyle(fontSize: 14.5.sp),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Feature 3
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.language,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  "Explore destinations from every continent.",
                                  style: TextStyle(fontSize: 14.5.sp),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),
                        Center(
                          child: Text(
                            "Let Zawal be the start of your next journey.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
