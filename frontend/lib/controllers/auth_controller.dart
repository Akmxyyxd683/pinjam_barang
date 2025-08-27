import 'package:frontend/widget/bottom_nav.dart';
import 'package:get/get.dart';
import 'package:frontend/services/api_services.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  final ApiService apiService = ApiService();

  login(String email, String password) async {
    var result = await apiService.login(email, password);
    if (result != null) {
      isLoggedIn.value = true;

      final userController = Get.put(UserController());
      userController.setUserData(result);

      Get.snackbar(
        "Login Successful",
        "Welcome back, $email!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
      Get.offAll(() => BottomNav());
    } else {
      Get.snackbar(
        "Login Failed",
        "Invalid username or password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }
}

class UserController extends GetxController {
  var name = ''.obs;
  var role = ''.obs;
  var id = ''.obs;

  void setUserData(Map<String, dynamic> userData) {
    name.value = userData['name'];
    role.value = userData['role'];
    id.value = userData['id'].toString();
  }
}
