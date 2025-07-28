import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final bool isDark;
  ThemeState({required this.isDark});
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(isDark: false));

  void toggleTheme() {
    emit(ThemeState(isDark: !state.isDark));
  }
}
