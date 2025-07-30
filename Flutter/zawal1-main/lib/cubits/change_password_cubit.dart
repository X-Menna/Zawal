import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/cubits/change_password_state.dart';
import 'package:zawal/models/change_password.dart';

import '../../dio.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit() : super(UpdatePasswordInitial());

  static UpdatePasswordCubit get(context) => BlocProvider.of(context);

  void updatePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(UpdatePasswordLoading());

    try {
      final response = await DioHelper.postData(
        url: 'auth/update-password',
        data: {
          'username': username,
          'currentpassword': currentPassword,
          'newpassword': newPassword,
        },
      );

      final model = UpdatePasswordModel.fromJson(response.data);
      emit(UpdatePasswordSuccess(model));
    } catch (e) {
      emit(UpdatePasswordError(e.toString()));
    }
  }
}
