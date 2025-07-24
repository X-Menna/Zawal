import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  // const String keyLogin = "login";
  @override
  void initState() {
    super.initState();
    checkLoginState();
  }

  void checkLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('login') ?? false;
    await Future.delayed(AppDurations.medium);

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/zawal_logo.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
