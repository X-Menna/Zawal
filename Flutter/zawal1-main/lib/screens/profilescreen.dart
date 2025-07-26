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
    loadUserData();
  }

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('image_path', pickedFile.path);

      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.file(_imageFile!, fit: BoxFit.contain),
              ),
            ),
          ),
    );
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';

      final imagePath = prefs.getString('image_path');
      if (imagePath != null) {
        _imageFile = File(imagePath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
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
                            backgroundColor: Colors.white,
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
                                        if (_imageFile != null)
                                          CustomProfileOption(
                                            icon: Icons.image,
                                            title: 'Shoe profile photo',
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _showFullImage(context);
                                            },
                                          ),

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
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.editprofile);
                },
              ),
              CustomProfileOption(
                icon: Icons.lock,
                title: 'Change password',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.changepassword);
                },
              ),
              CustomProfileOption(
                icon: Icons.favorite,
                title: 'Loved',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.favorite);
                },
              ),
              CustomProfileOption(
                icon: Icons.brightness_6,
                title: 'Change theme',
                onTap: () {},
              ),
              CustomProfileOption(
                icon: Icons.info,
                title: 'About',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.about);
                },
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
                            backgroundColor: AppColors.white,
                            title: const Text("confirmation"),
                            content: const Text(
                              "Are you sure you want to log out",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.profile,
                                  );
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
