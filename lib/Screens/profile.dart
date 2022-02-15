import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'sharedpreferences.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getemail();
    getimage();
    getname();
    getname();
  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.popAndPushNamed(context, '/home');
    }
    if (_selectedIndex == 1) {
      Navigator.popAndPushNamed(context, '/post');
    }
  }

  String? file;
  String? name;
  String? email;
  String? location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('profile')),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Column(children: [
              // Container(
              //   child: ClipOval(
              //     child: Image.file(
              //       file!,
              //       width: 160,
              //       height: 160,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),file != null
              file!=null? ClipOval(
                  child: Image.file(
                    File(file!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.network(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                ),
              Container(
                child: Text(
                  name ?? email ?? file ?? location ?? 'null',
                ),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'the price'),
                  keyboardType: TextInputType.number,
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'description'),
                  maxLines: 5,
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              ),
            ]),
          ]),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'posting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }

  getname() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    name = preference.getString('name');
  }

  getemail() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    email = preference.getString('email');
    setState(() {});
  }

  getimage() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    file = preference.getString('image');
  }

  getlocation() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    location = preference.getString('location');
  }
}
