import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/constants/app_textstyles.dart';
import 'package:zawal/routes/app_routes.dart';
import 'package:zawal/widgets/custom_Profile_option.dart';
//import '../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: Text('Profile', style: AppTextStyles.heading),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.white,
                      child: Icon(Icons.person, color: AppColors.grey),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 4.w,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Text('SaraYounan', style: AppTextStyles.heading),
              SizedBox(height: 20.h),

              CustomProfileOption(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () {},
              ),
              CustomProfileOption(
                icon: Icons.lock,
                title: 'Change password',
                onTap: () {},
              ),
              CustomProfileOption(
                icon: Icons.favorite,
                title: 'Loved',
                onTap: () {},
              ),
              CustomProfileOption(
                icon: Icons.brightness_6,
                title: 'Change theme',
                onTap: () {},
              ),
              CustomProfileOption(
                icon: Icons.info,
                title: 'About',
                onTap: () {},
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: 300.w,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.welcome);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    //minimumSize: Size(double.infinity),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
