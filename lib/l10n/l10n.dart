import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ar'),
    const Locale('ku','IQ'),
  ];
  static String getFlag(String code){
    switch (code) {
      case 'en':
        return 'πΊπΈ';
      case 'ar':
        return 'πΈπ¦';
      case 'ku':
        return 'ku';
      default:
        return 'πΊπΈ';
    }
  }
}
