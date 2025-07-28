import 'package:flutter/material.dart';
import 'package:zawal/screens/Home_screen.dart';
import 'package:zawal/screens/reccomendation_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/profilescreen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/about_screen.dart';
import '../screens/favorite_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case AppRoutes.logo:
        page = const SplashScreen();
        break;
      case AppRoutes.welcome:
        page = const WelcomeScreen();
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
      case AppRoutes.editprofile:
        page = const EditProfileScreen();
        break;
      case AppRoutes.changepassword:
        page = const ChangePasswordScreen();
        break;
      case AppRoutes.favorite:
        page = const FavoriteScreen();
        break;
      case AppRoutes.about:
        page = const AboutScreen();
        break;
      case AppRoutes.result:
        final args = settings.arguments as Map<String, dynamic>;
        page = RecommendationScreen(response: args);
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
      transitionDuration: const Duration(milliseconds: 500),
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
  static const editprofile = '/editprofile';
  static const changepassword = '/changepassword';
  static const favorite = '/favorite';
  static const about = '/about';
  static const result = '/result';
}
