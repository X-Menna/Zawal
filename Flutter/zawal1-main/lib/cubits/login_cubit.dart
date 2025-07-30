import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/constants/end_points.dart';
import 'package:zawal/models/login_model.dart';
import '../../dio.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email, required String password}) async {
    emit(LoginLoadingState());

    try {
      final response = await DioHelper.postData(
        url: EndPoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final model = LoginModel.fromJson(response.data);
        emit(LoginSuccessState(model));
      } else {
        emit(LoginNoDataState());
      }
    } catch (e) {
      emit(LoginErrorState(e.toString()));
    }
  }
}
