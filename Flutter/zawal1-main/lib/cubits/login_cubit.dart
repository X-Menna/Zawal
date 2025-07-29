import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/cubits/login_state.dart';
import 'package:zawal/dio.dart';
import 'package:zawal/models/login_model.dart';
import 'package:zawal/constants/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  late LoginModel loginModel;

  void userLogin({required String email, required String password}) async {
    emit(LoginLoadingState());

    await DioHelper.postData(
          url: EndPoints.login,
          data: {'email': email, 'password': password},
        )
        .then((value) {
          if (value.data['status'] == true) {
            loginModel = LoginModel.fromJson(value.data);
            emit(LoginSuccessState());
          } else {
            emit(LoginNoDataState());
          }
        })
        .catchError((error) {
          emit(LoginErrorState());
        });
  }
}
