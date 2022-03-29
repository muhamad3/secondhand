// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({Key? key}) : super(key: key);

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final emailcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextFormField(
              controller: emailcontroller,
              textInputAction: TextInputAction.done,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'example@gmail.com'),
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'enter a valid email '
                      : null,
            ),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              ),
              onPressed: () async{
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                content: Text("an email has been sent to ${emailcontroller.text}")));
                await FirebaseAuth.instance
                .sendPasswordResetEmail(email: emailcontroller.text.trim());
                Navigator.popAndPushNamed(context, '/login');
              },
              child: const Text('Reset Password')),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              ),
              onPressed: () {
                
                Navigator.popAndPushNamed(context, '/login');
              },
              child: const Text('go back', style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }



}
