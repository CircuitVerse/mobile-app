import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  var currentLocale = const Locale('en').obs;
  var isLanguageExpanded = false.obs;
  var isRTL = false.obs;

  // Supported languages with their display names and RTL status
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
    // Removed unnecessary Get.forceAppUpdate()
  }

  void toggleExpansion() {
    isLanguageExpanded.value = !isLanguageExpanded.value;
  }

  // Simplified RTL checking - no fallback needed since we control the supported languages
  bool _isLanguageRTL(Locale locale) {
    return supportedLanguages[locale]?['isRTL'] ?? false;
  }

  // Helper method to get language name
  String getLanguageName(Locale locale) {
    return supportedLanguages[locale]?['name'] ??
        locale.languageCode.toUpperCase();
  }

  // Get all supported locales
  List<Locale> get supportedLocales => supportedLanguages.keys.toList();
}
