import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/constants/app_textstyles.dart';
import 'package:zawal/routes/app_routes.dart';
import 'package:zawal/widgets/app_button.dart';
import 'package:zawal/widgets/custom_confirmation_dialog.dart';
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

      body: SingleChildScrollView(
        child: Padding(
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
                AppButton(
                  text: 'Edite',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => CustomConfirmationDialog(
                            title: 'Confirmation',
                            content:
                                'Are you sure you want to save the changes?',
                            confirmText: 'Save',
                            cancelText: 'Cancel',
                            onConfirm: () {
                              Navigator.pop(context);
                              saveUserData();
                            },
                            onCancle: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.profile,
                              );
                            },
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
