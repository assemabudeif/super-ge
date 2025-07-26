import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

/// The login screen for the application.
///
/// This view provides a user interface for users to enter their phone number
/// and password to log in. It uses a `Form` for validation and displays a
/// modern, card-based UI.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (LoginController controller) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Phone number input field.
                      TextFormField(
                        // keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => controller.phone.value = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى ادخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password input field with a toggle for visibility.
                      Obx(
                        () => TextFormField(
                          obscureText: controller.hidePassword.value,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(controller.hidePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: controller.togglePassword,
                            ),
                          ),
                          onChanged: (value) =>
                              controller.password.value = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى ادخال كلمة المرور';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Login button or loading indicator.
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: controller.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: controller.login,
                                child: const Text(
                                  'دخول',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
