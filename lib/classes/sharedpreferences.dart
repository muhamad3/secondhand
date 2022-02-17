import 'package:shared_preferences/shared_preferences.dart';

class Sharedpreference {

  static Future<void> setuser(name, email, image, location,phonenumber) async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString('name', name ?? 'no name available');
    print(name);
    preference.setString('email', email ?? 'no email available');
    print(email);
    preference.setString('image', image ?? 'no image available');
    print(image);
    preference.setString('location', location ?? 'no location available');
    print(location);
    preference.setString('phonenumber', phonenumber ?? 'no location available');
    print(phonenumber);
  }
}
