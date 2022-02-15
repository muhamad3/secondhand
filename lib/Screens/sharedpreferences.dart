import 'package:shared_preferences/shared_preferences.dart';

class Sharedpreference {
  Future<void> setusername(thename) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('username', thename ?? 'no name');
  }

  //  getname() async {
  //   final SharedPreferences preference = await SharedPreferences.getInstance();
  //   preference.getString('email');
  // }

  // getemail() async {
  //   final SharedPreferences preference = await SharedPreferences.getInstance();
  //   return preference.getString('email');
  // }

  //  getimage() async {
  //   final SharedPreferences preference = await SharedPreferences.getInstance();
  //   return preference.getString('image');
  // }

  //  getlocation() async {
  //   final SharedPreferences preference = await SharedPreferences.getInstance();
  //   return preference.getString('location');
  // }

  static Future<void> setuser(name, email, image, location) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('name', name ?? 'no name available');
    print(name);
    preference.setString('email', email ?? 'no email available');
    print(email);
    preference.setString('image', image ?? 'no image available');
    print(image);
    preference.setString('location', location ?? 'no location available');
    print(location);
  }
}
