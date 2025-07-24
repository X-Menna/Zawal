import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/constants/app_textstyles.dart';
import 'package:zawal/routes/app_routes.dart';
import 'package:zawal/widgets/custom_profile_option.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username = 'user';
  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      backgroundColor: AppColors.grey,
                      backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!) as ImageProvider
                              : null,
                      child:
                          _imageFile == null
                              ? Icon(
                                Icons.person,
                                color: AppColors.grey,
                                size: 50.r,
                              )
                              : null,
                    ),

                    Positioned(
                      bottom: 0,
                      right: 4.w,

                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.r),
                              ),
                            ),
                            builder:
                                (context) => SafeArea(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.h,
                                      horizontal: 16.w,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_imageFile != null) ...[
                                          Text(
                                            'Show profile photo',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              15.r,
                                            ),
                                            child: Image.file(
                                              _imageFile!,
                                              width: 140.w,
                                              height: 140.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                        ],

                                        CustomProfileOption(
                                          icon: Icons.camera_alt,
                                          title: 'Take a photo',
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            _pickImage(ImageSource.camera);
                                          },
                                        ),
                                        CustomProfileOption(
                                          icon: Icons.photo_library,
                                          title: 'Choose from gallery',
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            _pickImage(ImageSource.gallery);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Text('$username', style: AppTextStyles.heading),
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
                    showDialog(
                      context: context,
                      builder:
                          ((context) => AlertDialog(
                            title: const Text("confirmation"),
                            content: const Text(
                              "Are you sure you want to log out",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                                child: const Text("cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('login', false);
                                  await prefs.clear();

                                  if (!context.mounted) return;

                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.welcome,
                                    (route) => false,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                                child: const Text("Log out"),
                              ),
                            ],
                          )),
                    );
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
