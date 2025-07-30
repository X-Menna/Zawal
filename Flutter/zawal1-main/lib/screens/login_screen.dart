import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawal/constants/app_colors.dart';
import 'package:zawal/cubits/login_cubit.dart';
import 'package:zawal/cubits/login_state.dart';
import 'package:zawal/widgets/app_button.dart';
import 'package:zawal/widgets/custom_textfield.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
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
                image: AssetImage("assets/images/welcomepage.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: BlocProvider(
                create: (context) => LoginCubit(),
                child: BlocConsumer<LoginCubit, LoginStates>(
                  listener: (context, state) async {
                    if (state is LoginSuccessState) {
                      final cubit = LoginCubit.get(context);
                      final prefs = await SharedPreferences.getInstance();

                      await prefs.setBool('login', true);
                      await prefs.setString('token', state.model.token);
                      await prefs.setString('email', state.model.email);
                      await prefs.setString('userId', state.model.userId);

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    } else if (state is LoginErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login failed. Please try again."),
                        ),
                      );
                    } else if (state is LoginNoDataState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid credentials.")),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Container(
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
                              "Welcome back",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            AppTextFormField(
                              controller: emailController,
                              hintText: 'Email',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Email";
                                }
                                if (!RegExp(r'[!@]').hasMatch(value)) {
                                  return "Email not valid";
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter password";
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
                            SizedBox(height: 25.h),
                            state is LoginLoadingState
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : AppButton(
                                  text: 'Log in',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passController.text,
                                      );
                                    }
                                  },
                                ),

                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Text(
                                  "Donot have an account?",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.text,
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.signup,
                                    );
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
