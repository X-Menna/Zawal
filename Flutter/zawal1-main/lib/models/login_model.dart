class LoginModel {
  final String message;
  final String token;
  final String userId;
  final String email;

  LoginModel({
    required this.message,
    required this.token,
    required this.userId,
    required this.email,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json['message'],
      token: json['token'],
      userId: json['userId'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'userId': userId,
      'email': email,
    };
  }
}
