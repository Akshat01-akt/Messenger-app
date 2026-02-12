import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // Observable for password visibility
  final isPasswordHidden = true.obs;

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    emailController.dispose();
    userNameController.dispose();
    nameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Clear all fields
  void clearFields() {
    emailController.clear();
    userNameController.clear();
    nameController.clear();
    passwordController.clear();
    phoneController.clear();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}