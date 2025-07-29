class RegisterModel {
  final String userId;
  final String username;
  final String password;

  RegisterModel({
    required this.userId,
    required this.username,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      userId: json['userId'],
      username: json['username'],
      password: json['password'],
    );
  }
}
