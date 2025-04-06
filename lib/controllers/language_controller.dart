import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  final currentLocale = const Locale('en').obs;

  void toggleLanguage() {
    if (currentLocale.value.languageCode == 'en') {
      currentLocale.value = const Locale('hi');
    } else {
      currentLocale.value = const Locale('en');
    }
    Get.updateLocale(currentLocale.value);
  }
}
