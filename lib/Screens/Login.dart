// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/classes/Users.dart';
import 'package:secondhand/classes/storage.dart';
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
        _user.name, _user.email, _user.location, _user.phonenumber);
    return _user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.person, size: 90, color: Colors.cyan),
        const SizedBox(
          height: 20,
        ),
        Container(
          child: TextField(
            controller: email,
            decoration: const InputDecoration(
                border:  OutlineInputBorder(), hintText: 'example@gmail.com'),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        Container(
          child: TextField(
            controller: password,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: '******'),
            obscureText: true,
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        ElevatedButton(
          onPressed: () async {
            Email = email.value.text;
            Email = Email.trim();
            Email = Email.toLowerCase();
            Password = password.value.text;
            getuser();
            loginWithEmailAndPassword(Email, Password);
            Sharedpreference.islogedin();
          },
          child: const Text('Login'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("don't have an account?"),
            TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/createacc');
                },
                child: const Text("create one",style: TextStyle(color: Colors.cyan))),
          ],
        ),
        TextButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/forgotpassword');
            },
            child: const Text("Forgot Password?",style: TextStyle(color: Colors.cyan),))
      ],
    ));
  }

  loginWithEmailAndPassword(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => Navigator.popAndPushNamed(context, '/home'));
  }
}
