import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:super_ge/core/theme/app_theme.dart';
import 'controllers/main_controller.dart';
import 'core/services/app_prefs.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.instance.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        init: MainController(),
        builder: (MainController controller) {
          log(controller.firstPage.toString());
          return GetMaterialApp(
            title: 'Super Ge',
            locale: const Locale('ar'),
            theme: AppTheme.instance.lightTheme,
            debugShowCheckedModeBanner: false,
            home: controller.firstPage,
          );
        });
  }
}
