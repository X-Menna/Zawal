import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/cubits/change_password_state.dart';
import 'package:zawal/dio.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);

  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());

    try {
      final response = await DioHelper.postData(
        url: 'auth/change-password', // تأكد من صحة المسار مع الباك
        data: {
          'userId': userId,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        emit(ChangePasswordSuccess());
      } else {
        emit(ChangePasswordError('Something went wrong'));
      }
    } catch (e) {
      emit(ChangePasswordError(e.toString()));
    }
  }
}
