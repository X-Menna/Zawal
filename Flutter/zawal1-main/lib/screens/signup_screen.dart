import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/cubits/register_cubit.dart';
import 'package:zawal/cubits/register_state.dart';
import 'package:zawal/widgets/app_button.dart';
import 'package:zawal/widgets/custom_textfield.dart';
import '../routes/app_routes.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final birthdateController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool confirmPassVisible = false;
  bool passVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) async {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.user.message)));

            if (!context.mounted) return;

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );

            emailController.clear();
            passController.clear();
            phoneController.clear();
          } else if (state is RegisterError) {
            print(' Register Error: ${state.error}');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,

            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.welcome,
                    (route) => false,
                  );
                },
              ),
            ),
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/welcomepage.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Form(
                        key: _formKey,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            SizedBox(height: 20.h),
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
                            SizedBox(height: 15.h),
                            AppTextFormField(
                              controller: emailController,
                              hintText: 'Email',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your Email";
                                }
                                if (!RegExp(r'[!@]').hasMatch(value)) {
                                  return "Email not valid";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 15.h),
                            AppTextFormField(
                              controller: birthdateController,
                              hintText: '1/1/2025',
                              icon: Icons.calendar_month,
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter your birthday";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15.h),
                            AppTextFormField(
                              controller: phoneController,
                              hintText: '+02',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter your phone";
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 15.h),
                            AppTextFormField(
                              controller: passController,
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !passVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter pasword";
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return "Password must contain at least one uppercase letter";
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return "Password must contain at least one number";
                                }
                                if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                                  return "Password must contain at least one from (!@#\$&*~)";
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passVisible = !passVisible;
                                  });
                                },
                                icon: Icon(
                                  passVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            AppTextFormField(
                              controller: confirmPassController,
                              hintText: 'Confirm password',
                              icon: Icons.lock_outline,
                              obscureText: !confirmPassVisible,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (value != passController.text) {
                                  return "Passwords do not match";
                                }

                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  confirmPassVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    confirmPassVisible = !confirmPassVisible;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 25.h),
                            AppButton(
                              text: 'Sign up',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                    username: usernameController.text,
                                    password: passController.text,
                                    email: emailController.text,
                                    birthDate: birthdateController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.text,
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
