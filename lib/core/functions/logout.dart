import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/views/login_view.dart';

void logout() {
  Get.defaultDialog(
    title: 'تسجيل الخروج',
    middleText: 'هل انت متاكد من تسجيل الخروج؟',
    textConfirm: 'نعم',
    textCancel: 'لا',
    onConfirm: () {
      AppPreferences.instance.clear();
      Get.offAll(() => const LoginView());
    },
  );
}
