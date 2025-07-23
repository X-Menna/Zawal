import 'package:flutter/material.dart';
import 'package:zawal/screens/Home_screen.dart';
import '../screens/logo.dart';
import '../screens/welcomeScreen.dart';
import '../screens/LoginScreen.dart';
import '../screens/SignupScreeen.dart';
import '../screens/ProfileScreen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case AppRoutes.logo:
        page = const logoScreen();
        break;
      case AppRoutes.welcome:
        page = const welcomeScreen();
        break;
      case AppRoutes.login:
        page = const LoginScreen();
        break;
      case AppRoutes.signup:
        page = const SignupScreen();
        break;
      case AppRoutes.home:
        page = const HomeScreen();
        break;
      case AppRoutes.profile:
        page = const ProfileScreen();
        break;
      default:
        page = const Scaffold(body: Center(child: Text('No route found')));
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        // 🌀 Fade transition
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 500), // سرعة الانتقال
    );
  }
}

class AppRoutes {
  static const logo = '/logo';
  static const welcome = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const profile = '/profile';
}
