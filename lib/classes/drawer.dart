import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:secondhand/classes/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);
  @override
  _NavigationDrawerWidget createState() => _NavigationDrawerWidget();
}

class _NavigationDrawerWidget extends State<NavigationDrawerWidget> {
  @override
  void initState() {
    super.initState();
    getemail();
    getname();
    getphonenumber();
  }

  String? file;
  String? name;
  String? email;
  String? image;
  String? phonenumber;
  bool? isdark;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.cyan,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    image ??
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  ' $name \n $email \n $phonenumber',
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            buildMenuItem(
                text: 'Logout',
                icon: Icons.power_settings_new,
                onclick: () {
                  Sharedpreference.setuser('', '', '', '');
                  Sharedpreference.isnotlogedin();
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/login');
                }),
            buildMenuItem(
                text: 'DarkTheme',
                icon: Icons.dark_mode,
                onclick: () {
                  Sharedpreference.dark(false);
                }),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onclick,
  }) {
    const color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: const TextStyle(color: color),
      ),
      onTap: onclick,
    );
  }

  getname() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    name = preference.getString('name');
    setState(() {});
  }

  getemail() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();

    isdark = preference.getBool('isdark');
    email = preference.getString('email');
    image = await firebase_storage.FirebaseStorage.instance
        .ref('users/$email')
        .getDownloadURL();
    setState(() {});
  }

  getphonenumber() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    phonenumber = preference.getString('phonenumber');
    setState(() {});
  }
}
