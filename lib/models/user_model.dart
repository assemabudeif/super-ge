import 'package:equatable/equatable.dart';

/// Represents a user in the application.
///
/// This model holds the details of a user, who can be an 'admin' or a 'mandob' (representative).
/// It includes authentication details and personal information.
/// It uses [Equatable] to facilitate comparisons.
class UserModel extends Equatable {
  /// The unique identifier for the user, typically from Firebase.
  final String? id;

  /// The name of the user.
  final String name;

  /// The phone number of the user, used for login.
  final String phone;

  /// The type of the user, e.g., 'admin' or 'mandob'.
  final String userType;

  /// The user's password, used for login. This is optional and may not be present in all contexts.
  final String? password;

  const UserModel({
    this.id,
    required this.name,
    required this.phone,
    required this.userType,
    this.password,
  });

  /// Creates a [UserModel] instance from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json, {String? id}) =>
      UserModel(
        id: id,
        name: json["name"],
        phone: json["phone"],
        userType: json["user_type"],
        // Password is not typically read from Firestore for security reasons.
      );

  /// Converts this [UserModel] instance to a JSON map.
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
