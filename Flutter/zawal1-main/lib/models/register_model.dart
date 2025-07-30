class RegisterModel {
  final String message;
  final String userId;
  final String username;
  final String password;

  RegisterModel({
    required this.message,
    required this.userId,
    required this.username,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message'],
      userId: json['userId'],
      username: json['username'],
      password: json['password'],
    );
  }
}
