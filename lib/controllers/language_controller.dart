import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  var currentLocale = const Locale('en').obs;
  var isLanguageExpanded = false.obs;
  var isRTL = false.obs;

  final Map<Locale, Map<String, dynamic>> supportedLanguages = {
    const Locale('en'): {'name': 'English', 'isRTL': false},
    const Locale('hi'): {'name': 'हिन्दी', 'isRTL': false},
    const Locale('ar'): {'name': 'العربية', 'isRTL': true},
  };

  @override
  void onInit() {
    super.onInit();
    // Initialize RTL status based on current locale
    isRTL.value = _isLanguageRTL(currentLocale.value);
  }

  void changeLanguage(Locale locale) {
    currentLocale.value = locale;
    isRTL.value = _isLanguageRTL(locale);
    Get.updateLocale(locale);
    isLanguageExpanded.value = false;
  }

  void toggleExpansion() {
    isLanguageExpanded.value = !isLanguageExpanded.value;
  }

  bool _isLanguageRTL(Locale locale) {
    return supportedLanguages[locale]?['isRTL'] ?? false;
  }

  String getLanguageName(Locale locale) {
    return supportedLanguages[locale]?['name'] ??
        locale.languageCode.toUpperCase();
  }

  List<Locale> get supportedLocales => supportedLanguages.keys.toList();
}
