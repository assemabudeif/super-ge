import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

enum SharedKey {
  userId,
  name,
  phone,
  userType,
}

class AppPreferences {
  AppPreferences._();

  static final AppPreferences instance = AppPreferences._();

  late SharedPreferences sharedPreferences;
  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    Future.delayed(const Duration(seconds: 1), () {
      log(getUserType().toString(), name: 'User Type');
      log(getUserId().toString(), name: 'User Id');
      log(getName().toString(), name: 'User Name');
      log(getPhone().toString(), name: 'User Phone');
    });
  }

  /// Save the user id to shared preferences
  Future<void> saveUserId(String userId) async {
    await sharedPreferences.setString(SharedKey.userId.name, userId);
  }

  /// Get the user id from shared preferences
  String? getUserId() {
    return sharedPreferences.getString(SharedKey.userId.name);
  }

  /// Save the user name to shared preferences
  Future<void> saveName(String name) async {
    await sharedPreferences.setString(SharedKey.name.name, name);
  }

  /// Get the user name from shared preferences
  String? getName() {
    return sharedPreferences.getString(SharedKey.name.name);
  }

  /// Save the user phone to shared preferences
  Future<void> savePhone(String phone) async {
    await sharedPreferences.setString(SharedKey.phone.name, phone);
  }

  /// Get the user phone from shared preferences
  String? getPhone() {
    return sharedPreferences.getString(SharedKey.phone.name);
  }

  /// Save the user type to shared preferences
  Future<void> saveUserType(String userType) async {
    await sharedPreferences.setString(SharedKey.userType.name, userType);
  }

  /// Get the user type from shared preferences
  String? getUserType() {
    return sharedPreferences.getString(SharedKey.userType.name);
  }

  /// Clear all the shared preferences
  Future<void> clear() async {
    await sharedPreferences.clear();
  }
}
