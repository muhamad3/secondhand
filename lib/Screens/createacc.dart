import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Createacc extends StatefulWidget {
  const Createacc({Key? key}) : super(key: key);

  @override
  _CreateaccState createState() => _CreateaccState();
}

class _CreateaccState extends State<Createacc> {
  TextEditingController? name = TextEditingController();
  TextEditingController? location = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();
  String Password = '';
  String? username;
  String Email = '';
  String? loc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 100,
        ),
        Image.network(
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          width: 100,
          height: 100,
          alignment: Alignment.center,
        ),
        Container(
          child: TextField(
            controller: name,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'your name'),
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
        ),
        Container(
          child: TextField(
            controller: email,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'example@gmail.com'),
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
        ),
        Container(
          child: TextField(
            controller: password,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'your password'),
            obscureText: true,
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        Container(
          child: const TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'your password again'),
            obscureText: true,
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        Container(
          child: TextField(
            controller: location,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'where are you from'),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        ElevatedButton(
          onPressed: () {
            Email = email?.value.text ?? 'no email available';
            username = name?.value.text;
            loc = location?.value.text;
            Password = password?.value.text ?? '';
            FirebaseFirestore.instance
                .collection('users')
                .add({'email': Email, 'name': username, 'location': loc});
            registerWithEmailAndPassword(Email, Password);
          },
          child: const Text('Register'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
            fixedSize: MaterialStateProperty.all(Size.fromWidth(180)),
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Already have an account?'))
      ],
    ));
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
        Navigator.pop(context);
  }
}
