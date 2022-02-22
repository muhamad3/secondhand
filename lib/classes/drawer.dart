import 'dart:io';

import 'package:flutter/material.dart';
import 'package:secondhand/classes/sharedpreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerWidget extends StatefulWidget {
  NavigationDrawerWidget({Key? key}) : super(key: key);
  @override
  _NavigationDrawerWidget createState() => _NavigationDrawerWidget();
}

class _NavigationDrawerWidget extends State<NavigationDrawerWidget> {
  @override
  void initState() {
    super.initState();
    getemail();
    getimage();
    getname();
    getphonenumber();
  }

  String? file;
  String? name;
  String? email;
  String? phonenumber;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                file != null
                    ? Container(
                        margin: EdgeInsets.all(10),
                        child: ClipOval(
                          child: Image.file(
                            File(file!),
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                          ),
                        ))
                    : ClipOval(
                        child: Image.network(
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                      )),
                Text(
                  ' $name \n $email \n $phonenumber',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
           
            buildMenuItem(
                text: 'Logout',
                icon: Icons.power_settings_new,
                onclick: () {
                  Sharedpreference.setuser('', '', '', '', '');
                  Sharedpreference.isnotlogedin();
                  Navigator.popAndPushNamed(context, '/login');
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
    final color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
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
    email = preference.getString('email');
    setState(() {});
  }

  getimage() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    file = preference.getString('image');
    setState(() {});
  }

  getphonenumber() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    phonenumber = preference.getString('phonenumber');
    setState(() {});
  }
}
