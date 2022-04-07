import 'package:flutter/material.dart';
import 'package:secondhand/classes/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  String lan = 'en';
  Locale get locale {
    getlan();
    return Locale(lan);
  }

  void setLocale(Locale locale) {
  // this is used to update the locale in the sharedpreference
    _locale == const Locale('en')
        ? Sharedpreference.language('ar')
        : Sharedpreference.language('en');
    //  this is used to update the locale in the provider
    _locale = _locale == const Locale('en') ?
     const Locale('ar') : const Locale('en');
    getlan();
    notifyListeners();
  }

  getlan() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    lan = preference.getString('language')!;
  }
}
