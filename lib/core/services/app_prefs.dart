import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

/// An enum for defining the keys used in shared preferences.
/// This helps avoid typos and ensures consistency.
enum SharedKey {
  userId,
  name,
  phone,
  userType,
}

/// A singleton class for managing application preferences using [SharedPreferences].
///
/// This class provides a centralized way to save and retrieve user-related data
/// such as user ID, name, phone number, and user type.
class AppPreferences {
  // Private constructor for the singleton pattern.
  AppPreferences._();

  // The single instance of the AppPreferences class.
  static final AppPreferences instance = AppPreferences._();

  late SharedPreferences sharedPreferences;

  /// Initializes the [SharedPreferences] instance.
  /// This must be called once at application startup.
  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    // Log the stored user data for debugging purposes after a short delay.
    Future.delayed(const Duration(seconds: 1), () {
      log(getUserType().toString(), name: 'User Type');
      log(getUserId().toString(), name: 'User Id');
      log(getName().toString(), name: 'User Name');
      log(getPhone().toString(), name: 'User Phone');
    });
  }

  /// Saves the user ID to shared preferences.
  Future<void> saveUserId(String userId) async {
    await sharedPreferences.setString(SharedKey.userId.name, userId);
  }

  /// Retrieves the user ID from shared preferences.
  String? getUserId() {
    return sharedPreferences.getString(SharedKey.userId.name);
  }

  /// Saves the user name to shared preferences.
  Future<void> saveName(String name) async {
    await sharedPreferences.setString(SharedKey.name.name, name);
  }

  /// Retrieves the user name from shared preferences.
  String? getName() {
    return sharedPreferences.getString(SharedKey.name.name);
  }

  /// Saves the user phone number to shared preferences.
  Future<void> savePhone(String phone) async {
    await sharedPreferences.setString(SharedKey.phone.name, phone);
  }

  /// Retrieves the user phone number from shared preferences.
  String? getPhone() {
    return sharedPreferences.getString(SharedKey.phone.name);
  }

  /// Saves the user type (e.g., 'admin', 'mandob') to shared preferences.
  Future<void> saveUserType(String userType) async {
    await sharedPreferences.setString(SharedKey.userType.name, userType);
  }

  /// Retrieves the user type from shared preferences.
  String? getUserType() {
    return sharedPreferences.getString(SharedKey.userType.name);
  }

  /// Clears all data from shared preferences.
  /// This is typically used during logout.
  Future<void> clear() async {
    await sharedPreferences.clear();
  }
}
