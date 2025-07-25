import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/constants/app_textstyles.dart';
import 'package:zawal/routes/app_routes.dart';
//import 'package:zawal/routes/app_routes.dart';
import 'package:zawal/widgets/custom_profileedite_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? username;
  String? birthdate;
  String? phone;

  final nameController = TextEditingController();
  final birthdateController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      birthdate = prefs.getString('birthdate');
      phone = prefs.getString('phone');

      nameController.text = username!;
      birthdateController.text = birthdate!;
      phoneController.text = phone!;
    });
  }

  void saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', nameController.text);
    await prefs.setString('birthdate', birthdateController.text);
    await prefs.setString('phone', phoneController.text);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Data edited successfully!')));

    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pushReplacementNamed(context, AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.profile);
          },
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: Text('Edit profile', style: AppTextStyles.heading),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),

      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomProfileEditeTextfield(
                labelText: 'Name',
                hintText: '$username',
                controller: nameController,
              ),

              CustomProfileEditeTextfield(
                labelText: 'BirthDate',
                hintText: '$birthdate',
                controller: birthdateController,
              ),

              CustomProfileEditeTextfield(
                labelText: 'Phone',
                hintText: '$phone',
                controller: phoneController,
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
                            title: const Text(
                              "confirmation",
                              style: TextStyle(color: AppColors.primary),
                            ),
                            content: const Text(
                              "Are you sure you want to save the changes?",
                              style: TextStyle(color: AppColors.primary),
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
                                  saveUserData();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                                child: const Text("ُSave"),
                              ),
                            ],
                          )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
