import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondhand/Screens/Post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/sharedpreferences.dart';
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
    getlocation();
    getphonenumber();
  }

  int _selectedIndex = 2;
  String? test;

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
  String? phonenumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Column(children: [
              file != null
                  ? ClipOval(
                      child: Image.file(
                        File(file!),
                        width: 150,
                        height: 150,
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
                child: Text(name ?? 'no name',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              ),
              Container(
                child: Text(
                  'location: lives in $location ',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              Container(
                child: Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              Container(
                child: Text(
                  'Phone number: $phonenumber',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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

  getphonenumber() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    phonenumber = preference.getString('phonenumber');
  }

 

}
