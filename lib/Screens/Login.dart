import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                border: OutlineInputBorder(), hintText: '********'),
            obscureText: true,
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        ElevatedButton(
          onPressed: () {
            Email = email.value.text;
            Password = password.value.text;
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
        .then((value) => Navigator.popAndPushNamed(context, '/home')).catchError((e) => debugPrint(e.toString()));
  }
}
