import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/cubits/theme_cubit.dart';
import 'package:zawal/cubits/trip_cubit.dart';
import 'package:zawal/routes/app_routes.dart';
import 'constants/app_colors.dart';
import 'constants/app_textstyles.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 680),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
            BlocProvider<TripCubit>(create: (_) => TripCubit()),
          ],
          child: MaterialApp(
            title: 'Zawal',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.background,
              fontFamily: 'Poppins',
              textTheme: const TextTheme(bodyMedium: AppTextStyles.body),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: AppColors.primary,
              fontFamily: 'Poppins',
            ),
            themeMode: ThemeMode.system,
            initialRoute: AppRoutes.logo,
            onGenerateRoute: AppRouter.generateRoute,
          ),
        );
      },
      child: SplashScreen(),
    );
  }
}
