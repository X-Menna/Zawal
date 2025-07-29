class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      birthDate: json['birthDate'],
      createdAt: DateTime.parse(json['create_at']),
      updatedAt: DateTime.parse(json['update_at']),
    );
  }
}
