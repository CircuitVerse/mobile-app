import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUtils {
  static void showLight(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.white,
      textColor: Colors.black,
    );
  }

  static void showDark(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      textColor: Colors.white,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    if (Get.context == null) return;

    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Future.microtask(() {
      Get.rawSnackbar(
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
        isDismissible: true,
        titleText: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          message,
          style: TextStyle(color: textColor),
        ),
      );
    });
  }
}