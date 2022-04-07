import 'package:shared_preferences/shared_preferences.dart';

class Sharedpreference {
  static Future<void> setuser(name, email, location, phonenumber) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('name', name ?? 'no name available');
    preference.setString('email', email ?? 'no email available');
    preference.setString('location', location ?? 'no location available');
    preference.setString('phonenumber', phonenumber ?? 'no location available');
  }

  static Future<void> setemail(email) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('email', email ?? 'no email available');
  }

  static Future<void> sellersemail(email) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('sellersemail', email ?? '');
  }

  static Future<void> revrsetalked(bool reverse) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('talked', reverse);
  }

  static Future<void> isfirsttime() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('firsttime', false);
  }

  static Future<void> islogedin() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('logedin', true);
  }

  static Future<void> isnotlogedin() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('logedin', false);
  }
  static Future<void> dark(bool isdark) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('isdark', isdark);
  }
  static Future<void> language(lan) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('language', lan ?? 'en');
  }
}
