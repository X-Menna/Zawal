import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zawal/cubits/theme_cubit.dart';
import 'package:zawal/cubits/trip_cubit.dart';
import 'package:zawal/dio.dart';
import 'package:zawal/routes/app_routes.dart';
import 'package:zawal/screens/splash_screen.dart';
import 'constants/app_colors.dart';
import 'constants/app_textstyles.dart';

void main() {
  //  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<TripCubit>(create: (_) => TripCubit(TripInitial())),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
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
              themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
              initialRoute: AppRoutes.logo,
              onGenerateRoute: AppRouter.generateRoute,
              home: SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
