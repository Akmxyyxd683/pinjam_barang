import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/widget/bottom_nav.dart';
import 'package:get/get.dart';
import 'package:frontend/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/biometric_auth_service.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  final ApiService apiService = ApiService();

  login(String email, String password) async {
    var result = await apiService.login(email, password);
    if (result != null) {
      final bioOk = await BiometricAuthService()
          .authenticate(reason: 'Gunakan sidik jari untuk melanjutkan');

      if (!bioOk) {
        Get.snackbar(
          "Verifikasi Gagal",
          "Autentikasi biometrik dibatalkan atau gagal",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return; // stop, jangan lanjut
      }

      // ✅ Biometrik sukses → set user & navigate
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

  void logout() {
    Get.defaultDialog(
        title: "Konfirmasi",
        middleText: "Apakah kamu yakin ingin logout?",
        textCancel: "Batal",
        textConfirm: "Logout",
        confirmTextColor: Colors.white,
        onConfirm: () {
          // eksekusi logout
          isLoggedIn.value = false;

          final userController = Get.find<UserController>();
          userController.clear();
          Get.offAll(() => LoginScreen());

          Get.snackbar(
            "Logged Out",
            "You have been logged out",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue[100],
            colorText: Colors.blue[800],
          );
        });
  }
}

class UserController extends GetxController {
  var name = ''.obs;
  var profile_img = ''.obs;
  var role = ''.obs;
  var id = ''.obs;

  void setUserData(Map<String, dynamic> userData) {
    name.value = userData['name'];
    profile_img.value = userData['profile_img'];
    role.value = userData['role'];
    id.value = userData['id'].toString();
  }

  void clear() {
    name.value = '';
    profile_img.value = '';
    role.value = '';
    id.value = '';
  }
}
