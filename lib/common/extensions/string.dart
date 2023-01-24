import 'package:flutter/material.dart';

extension LanguageName on Locale {
  String get languageName {
    switch (languageCode) {
      case 'en':
        return 'English';

      case 'es':
        return 'Español';
    }
    return '';
  }
}

extension StringExtensions on String {
  bool isUpperCase() {
    return this == toUpperCase();
  }
}
