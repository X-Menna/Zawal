class UpdatePasswordModel {
  final String message;

  UpdatePasswordModel({required this.message});

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordModel(message: json['message']);
  }
}
