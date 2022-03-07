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
              decoration: InputDecoration(
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
              onPressed: () {
                opendialog();
                Resetpassword();
              },
              child: Text('Reset Password')),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              ),
              onPressed: () {
                
                Navigator.popAndPushNamed(context, '/login');
              },
              child: Text('go back', style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }

  Future opendialog() => showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
              content: Container(
            width: 300,
            height: 100,
            child: Text(
                'an email has been sent to this account ${emailcontroller.text}'),
          )));

  Future Resetpassword() async {
  await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailcontroller.text.trim());
    Navigator.popAndPushNamed(context, '/login');
  }
}
