import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/classes/Users.dart';
import 'package:secondhand/classes/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/sharedpreferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String Email = '';
  String Password = '';

  final Storage storage = Storage();

  String? mail = 'no email available';
  String? name = 'no name available';
  String? phonenumber = 'no phonenumber available';
  String? location = 'no location available';
  String image = '';

  Stream<List<Users>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromMap(doc.data())).toList());

  Future<Users> getuser() async {
    var value =
        await FirebaseFirestore.instance.collection('users').doc(Email).get();
    Users _user = Users.fromMap(value.data() as Map<String, dynamic>);
    Sharedpreference.setuser(
        _user.name, _user.email, _user.image, _user.location, _user.phonenumber);
    debugPrint(_user.toString());
    return _user;
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.person, size: 90, color: Colors.cyan),
        const SizedBox(
          height: 20,
        ),
        Container(
          child: TextField(
            controller: email,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'example@gmail.com'),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        Container(
          child: TextField(
            controller: password,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: '******'),
            obscureText: true,
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        ElevatedButton(
          onPressed: () async {
            Email = email.value.text;
            Password = password.value.text;
            getuser();
            loginWithEmailAndPassword(Email, Password);
          },
          child: const Text('Login'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
          ),
        ),
        SizedBox(height: 20),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/createacc');
            },
            child: const Text('don' 't have an account?'))
      ],
    ));
  }

  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => Navigator.popAndPushNamed(context, '/home'))
        .catchError((e) => debugPrint(e.toString()));
  }
}
