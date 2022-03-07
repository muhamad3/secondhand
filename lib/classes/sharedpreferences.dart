import 'package:shared_preferences/shared_preferences.dart';

class Sharedpreference {
  static Future<void> setuser(name, email, location, phonenumber) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('name', name ?? 'no name available');
    print(name);
    preference.setString('email', email ?? 'no email available');
    print(email);
    preference.setString('location', location ?? 'no location available');
    print(location);
    preference.setString('phonenumber', phonenumber ?? 'no location available');
    print(phonenumber);
  }

  static Future<void> setemail(email) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('email', email ?? 'no email available');
  }

  static Future<void> sellersemail(email) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('sellersemail', email ?? 'no email available');
  }

  static Future<void> isfirsttime() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('firsttime', false);
  }

  static Future<void> islogedin() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('logedin', true);
    print('the loged in is true');
  }

  static Future<void> isnotlogedin() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('logedin', false);
    print('logedin false');
  }
}
