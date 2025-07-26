import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/views/admin_home.dart';
import 'package:super_ge/views/login_view.dart';
import 'package:super_ge/views/mandob_home.dart';

/// The main controller for the application.
///
/// This class determines the initial screen to be displayed when the app starts.
/// It checks if a user is already logged in and directs them to the appropriate
/// home screen (`AdminHome` or `MandobHome`) or to the `LoginView` if not.
class MainController extends GetxController {
  // The initial widget to be displayed. Defaults to LoginView.
  Widget firstPage = const LoginView();

  @override
  void onInit() {
    // Check if a user ID is stored in shared preferences.
    if (AppPreferences.instance.getUserId() == null) {
      // If no user is logged in, show the login view.
      firstPage = const LoginView();
    } else {
      // If a user is logged in, determine their type and show the corresponding home screen.
      if (AppPreferences.instance.getUserType() == 'admin') {
        firstPage = const AdminHome();
      } else {
        firstPage = const MandobHome();
      }
    }
    super.onInit();
  }
}
