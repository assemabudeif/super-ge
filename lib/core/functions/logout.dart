import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/views/login_view.dart';

/// Displays a confirmation dialog and logs the user out if confirmed.
///
/// This function shows a dialog to confirm the logout action. If the user
/// confirms, it clears all data from shared preferences and navigates
/// the user back to the `LoginView`.
void logout() {
  Get.defaultDialog(
    title: 'تسجيل الخروج',
    middleText: 'هل انت متاكد من تسجيل الخروج؟',
    textConfirm: 'نعم',
    textCancel: 'لا',
    onConfirm: () {
      // Clear all stored user preferences.
      AppPreferences.instance.clear();
      // Navigate to the login screen, removing all previous routes.
      Get.offAll(() => const LoginView());
    },
  );
}
