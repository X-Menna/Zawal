import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawal/models/user_model.dart';
import 'package:zawal/dio.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  void updateProfile({
    required String userId,
    required String name,
    required String phone,
    required String birthDate,
  }) async {
    emit(EditProfileLoading());

    try {
      final response = await DioHelper.postData(
        url: 'updateUserProfile',
        data: {
          "user_id": userId,
          "name": name,
          "phone": phone,
          "birth_date": birthDate,
          "country": "any",
          "budget": 0,
          "age": 0,
          "activities": [],
          "is_solo_travel": false,
          "is_kid_friendly_required": false,
          "language": "en",
          "season": "any",
        },
      );

      final user = UserModel.fromJson(response.data);
      emit(EditProfileSuccess(user));
    } catch (error) {
      emit(EditProfileError(error.toString()));
    }
  }
}
