import 'package:flutter/material.dart';
import '../l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale get locale => _locale ??= const Locale('en');

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = const Locale('ar');
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
