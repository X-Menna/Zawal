import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/models/register_model.dart';
import 'package:zawal/dio.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String username,
    required String email,
    required String password,
    String? birthDate,
    String? phone,
  }) async {
    emit(RegisterLoading());
    try {
      final response = await DioHelper.postData(
        url: 'auth/register', // POST /api/auth/register
        data: {
          "username": username,
          "email": email,
          "password": password,
          "birthDate": birthDate,
          "phone": phone,
        },
      );

      final user = RegisterModel.fromJson(response.data);
      emit(RegisterSuccess(user));
    } catch (error) {
      emit(RegisterFailure(error.toString()));
    }
  }
}
