import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_ge/core/services/app_prefs.dart';
import 'package:super_ge/views/add_new_client_entry.dart';
import 'package:super_ge/views/admin_home.dart';
import 'package:super_ge/views/login_view.dart';
import 'package:super_ge/views/mandob_home.dart';

class MainController extends GetxController {
  Widget firstPage = const LoginView();

  @override
  void onInit() {
    if (AppPreferences.instance.getUserId() == null) {
      firstPage = const LoginView();
    } else {
      if (AppPreferences.instance.getUserType() == 'admin') {
        firstPage = const AdminHome();
      } else {
        firstPage = const MandobHome();
      }
    }
    super.onInit();
  }
}
