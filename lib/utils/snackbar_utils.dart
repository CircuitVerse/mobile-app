import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUtils {
  static void showLight(String message, {String title}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showDark(String message, {String title}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
