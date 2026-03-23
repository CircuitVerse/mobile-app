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

  static void showDarkWithContext(
    BuildContext context,
    String title,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.85),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
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