import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/constants/app_strings.dart';
import 'package:zawal/constants/app_textstyles.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../routes/app_routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String selectedButton = '';
  @override
  void initState() {
    super.initState();
    selectedButton = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcomepage.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.welcomeTitle,
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      AppStrings.welcomeSubtitle,
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppStrings.login,
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                            isSelected: false,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: CustomButton(
                            text: AppStrings.signup,
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                            isSelected: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
