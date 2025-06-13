import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  var currentLocale = const Locale('en').obs;
  var isLanguageExpanded = false.obs;

  void changeLanguage(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
    isLanguageExpanded.value = false; // manually collapse
  }

  void toggleExpansion() {
    isLanguageExpanded.value = !isLanguageExpanded.value;
  }
}
