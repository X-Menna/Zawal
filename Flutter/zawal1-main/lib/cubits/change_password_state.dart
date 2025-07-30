import 'package:zawal/models/change_password.dart';

abstract class UpdatePasswordState {}

class UpdatePasswordInitial extends UpdatePasswordState {}

class UpdatePasswordLoading extends UpdatePasswordState {}

class UpdatePasswordSuccess extends UpdatePasswordState {
  final UpdatePasswordModel model;

  UpdatePasswordSuccess(this.model);
}

class UpdatePasswordError extends UpdatePasswordState {
  final String error;

  UpdatePasswordError(this.error);
}
