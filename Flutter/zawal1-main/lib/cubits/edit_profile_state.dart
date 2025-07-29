import 'package:zawal/models/user_model.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final UserModel user;

  EditProfileSuccess(this.user);
}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError(this.message);
}
