import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:super_ge/core/theme/app_theme.dart';
import 'controllers/main_controller.dart';
import 'core/services/app_prefs.dart';
import 'firebase_options.dart';

/// The main entry point of the application.
Future<void> main() async {
  // Ensure that the Flutter binding is initialized before calling native code.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize shared preferences to load any saved user data.
  await AppPreferences.instance.init();

  // Initialize Firebase with the platform-specific options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the application.
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GetBuilder to initialize the MainController, which determines the initial screen.
    return GetBuilder<MainController>(
        init: MainController(),
        builder: (MainController controller) {
          log(controller.firstPage.toString());
          // GetMaterialApp is the root of the GetX-based application.
          return GetMaterialApp(
            title: 'Super Ge',
            locale: const Locale('ar'), // Set the default locale to Arabic.
            theme:
                AppTheme.instance.lightTheme, // Apply the custom light theme.
            debugShowCheckedModeBanner: false,
            // The home screen is determined by the MainController.
            home: controller.firstPage,
          );
        });
  }
}
