import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../classes/firebaseapi.dart';
import '../classes/sharedpreferences.dart';

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
  TextEditingController? phonenum = TextEditingController();
  String Password = '';
  String phonenumber = '';
  String? username;
  String Email = '';
  String? loc;
  String? urldownload;
  Future pickimage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => file = imageTemporary);
  }

  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          file != null
              ? ClipOval(
                  child: Image.file(
                    file!,
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
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              ),
              onPressed: () {
                pickimage();
              },
              child: const Text('pick an image from gallery ')),
          Container(
            child: TextField(
              controller: name,
              decoration: const InputDecoration(
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          Container(
            child: TextField(
              controller: password,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'your password'),
              obscureText: true,
            ),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          Container(
            child: TextField(
              controller: phonenum,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'your phone number'),
              keyboardType: TextInputType.phone,
            ),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          Container(
            child: TextField(
              controller: location,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'where do you live'),
            ),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          ElevatedButton(
            onPressed: () async {
              Password = password?.value.text ?? '';
              phonenumber = phonenum?.value.text ?? '';
              Email = email?.value.text ?? 'no email available';
              username = name?.value.text;
              loc = location?.value.text;
              await uploadFile();

              await registerWithEmailAndPassword(Email, Password);
              FirebaseFirestore.instance.collection('users').doc(Email).set({
                'email': Email,
                'name': username,
                'location': loc,
                'phonenumber': phonenumber,
                'image': file?.path
              });

              Sharedpreference.setuser(username, Email, loc, phonenumber);
              Sharedpreference.islogedin();
              Navigator.popAndPushNamed(this.context, '/home');
            },
            child: const Text('Register'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              fixedSize: MaterialStateProperty.all(const Size.fromWidth(180)),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/login');
              },
              child: const Text('Already have an account?'))
        ],
      )
    ])));
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    String? a = _firebaseAuth.currentUser!.uid;
    print(a);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final destination = 'users/$Email';
    task = FirebaseApi.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});

    await snapshot.ref.getDownloadURL().then((value) => setState(() {
          urldownload = value;
          debugPrint(urldownload);
        }));

    print('Download-Link: $urldownload');
  }
}
