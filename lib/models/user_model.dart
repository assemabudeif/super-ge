import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id;
  final String name;
  final String phone;
  final String userType;
  final String? password;

  const UserModel({
    this.id,
    required this.name,
    required this.phone,
    required this.userType,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? id}) =>
      UserModel(
        id: id,
        name: json["name"],
        phone: json["phone"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "user_type": userType,
        "password": password,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        userType,
        password,
      ];
}
