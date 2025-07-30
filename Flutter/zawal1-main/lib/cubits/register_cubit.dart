import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:zawal/constants/end_points.dart';
import 'package:zawal/cubits/register_state.dart';
import 'package:zawal/dio.dart';
import 'package:zawal/models/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  Future<void> userRegister({
    required String username,
    required String password,
    required String email,
    required String birthDate,
    required String phone,
  }) async {
    emit(RegisterLoading());

    try {
      final response = await DioHelper.postData(
        url: EndPoints.register,
        data: {
          'username': username,
          'password': password,
          'email': email,
          'birthDate': birthDate,
          'phone': phone,
        },
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE VALUE: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = RegisterModel.fromJson(response.data);

        // ممكن تخزني البيانات هنا لو حبيتي
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', model.userId);
        await prefs.setString('username', model.username);

        emit(RegisterSuccess(model));
      } else {
        emit(
          RegisterError('Register failed with status: ${response.statusCode}'),
        );
      }
    } catch (error) {
      emit(RegisterError('Error: $error'));
    }
  }
}
