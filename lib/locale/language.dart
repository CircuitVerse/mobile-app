class L10n {
  static String getLanguage(String code) {
    switch (code) {
      case 'hi':
        return '🇮🇳 Hindi';
      case 'en':
        return '🇺🇸 English';
      default:
        return '🇺🇸 English';
    }
  }
}
