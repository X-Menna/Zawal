import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/constants/app_textstyles.dart';
import 'package:zawal/cubits/change_password_cubit.dart';
import 'package:zawal/cubits/change_password_state.dart';
import 'package:zawal/routes/app_routes.dart';
import 'package:zawal/widgets/app_button.dart';
import 'package:zawal/widgets/custom_confirmation_dialog.dart';
import 'package:zawal/widgets/custom_textfield.dart';
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
  final usernameController = TextEditingController();

  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  String? currentPasswordError;

  void _changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString('password');

    if (currentpassController.text != storedPassword) {
      setState(() {
        currentPasswordError = 'Old password is incorrect';
        currentpassController.clear();
        newpassController.clear();
        confirmPassController.clear();
      });
      _formKey.currentState!.validate();
      return;
    }

    if (_formKey.currentState!.validate()) {
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

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: BlocConsumer<UpdatePasswordCubit, UpdatePasswordState>(
            listener: (context, state) {
              if (state is UpdatePasswordSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.model.message)));
              } else if (state is UpdatePasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      controller: usernameController,
                      hintText: 'Name',
                      icon: Icons.person,
                      keyboardType: TextInputType.name,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.h),

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
                        if (currentPasswordError != null) {
                          final error = currentPasswordError;
                          currentPasswordError = null;
                          return error;
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
                    AppButton(
                      text: 'Change Password',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => CustomConfirmationDialog(
                                title: 'Confirmation',
                                content:
                                    'Are you sure you want to change your password?',
                                confirmText: 'Change',
                                cancelText: 'Cancel',
                                onConfirm: () {
                                  Navigator.pop(context);
                                  UpdatePasswordCubit.get(
                                    context,
                                  ).updatePassword(
                                    username: usernameController.text.trim(),
                                    currentPassword:
                                        currentpassController.text.trim(),
                                    newPassword: newpassController.text.trim(),
                                  );
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
              );
            },
          ),
        ),
      ),
    );
  }
}


/*Form(
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
                    if (currentPasswordError != null) {
                      final error = currentPasswordError;
                      currentPasswordError = null;
                      return error;
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
                AppButton(
                  text: 'Change Password',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => CustomConfirmationDialog(
                            title: 'Confirmation',
                            content:
                                'Are you sure you want to change your password?',
                            confirmText: 'Change',
                            cancelText: 'Cancel',
                            onConfirm: () {
                              Navigator.pop(context);
                              _changePassword();
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
          ),*/