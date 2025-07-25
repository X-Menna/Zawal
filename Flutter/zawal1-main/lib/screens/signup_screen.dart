import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawal/constants/app_colors.dart';
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
  Widget build(BuildContext context) {
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
                image: AssetImage("assets/images/zawal_logo.png"),
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
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "the name require";
                          }
                          return null;
                        },
                        controller: usernameController,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          hintText: 'name',
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "the email require";
                          }
                          if (!RegExp(r'[!@]').hasMatch(value)) {
                            return "Email not valid";
                          }
                          return null;
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),

                      SizedBox(height: 15.h),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter your birthday";
                          }
                          return null;
                        },
                        controller: birthdateController,
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          hintText: '5/5/2025',
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                      ),

                      SizedBox(height: 15.h),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter your phone";
                          }
                          return null;
                        },
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          hintText: '+02',
                          prefixIcon: const Icon(Icons.phone),
                        ),
                      ),

                      SizedBox(height: 15.h),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return " the password require";
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
                        controller: passController,
                        obscureText: !passVisible,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          hintText: 'password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                passVisible = !passVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        controller: confirmPassController,
                        style: TextStyle(color: Colors.black),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          hintText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),
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
                      ),
                      SizedBox(height: 25.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),

                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('login', true);
                              await prefs.setString(
                                'username',
                                usernameController.text,
                              );

                              await prefs.setString(
                                'birthdate',
                                birthdateController.text,
                              );

                              await prefs.setString(
                                'phone',
                                phoneController.text,
                              );
                              await prefs.setString(
                                'password',
                                passController.text,
                              );

                              if (!context.mounted) return;

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.profile,
                                (rout) => false,
                              );

                              emailController.clear();
                              passController.clear();
                              phoneController.clear();
                            }
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
                                  builder: (context) => const LoginScreen(),
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
  }
}
