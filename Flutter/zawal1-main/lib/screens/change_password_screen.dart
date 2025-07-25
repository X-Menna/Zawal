import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/constants/app_textstyles.dart';
import 'package:zawal/routes/app_routes.dart';
import 'package:zawal/widgets/password_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final currentpassController = TextEditingController();
  final newpassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      String? storedPassword = prefs.getString('password');

      if (currentpassController.text != storedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Old password is incorrect")),
        );
        return;
      }

      await prefs.setString('password', newpassController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    }
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
              PasswordField(
                controller: currentpassController,
                label: 'Current password',
                isVisible: _isCurrentVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isCurrentVisible = !_isCurrentVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              PasswordField(
                controller: newpassController,
                label: 'New password',
                isVisible: _isNewVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isNewVisible = !_isNewVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return "Password must contain at least one uppercase letter";
                  }
                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return "Password must contain at least one number";
                  }
                  if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                    return "Password must contain at least one special character (!@#\$&*~)";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              PasswordField(
                controller: confirmPassController,
                label: 'Confirm New password',
                isVisible: _isConfirmVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isConfirmVisible = !_isConfirmVisible;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm new password';
                  }
                  if (value != newpassController.text) {
                    return 'password donot match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
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
                              "Are you sure you want to change your password?",
                              style: TextStyle(color: AppColors.primary),
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
                                  _changePassword();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                                child: const Text("ُChange"),
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
                    "Change password",
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
