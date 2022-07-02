// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/firebaseapi.dart';
import '../classes/sharedpreferences.dart';

class Profiledit extends StatefulWidget {
  const Profiledit({Key? key}) : super(key: key);

  @override
  _CreateaccState createState() => _CreateaccState();
}

class _CreateaccState extends State<Profiledit> {
  TextEditingController? name = TextEditingController();
  TextEditingController? location = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();
  TextEditingController? phonenum = TextEditingController();
  String Password = '';
  String phonenumber = '';
  String? username;
  String? Email;
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
  void initState() {
    super.initState();
    getuser();
    setState(() {});
  }

  getuser() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    Email = preference.getString('email')!;
    email = Email!=null?TextEditingController(text: Email):TextEditingController();
    username = preference.getString('name');
    name = username!=null?TextEditingController(text: username):TextEditingController();
    phonenumber = preference.getString('phonenumber')!;
    phonenum = TextEditingController(text: phonenumber);
    loc = preference.getString('location');
    location = loc!=null?TextEditingController(text: loc):TextEditingController();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,backgroundColor: Colors.cyan,
        title: const Text('Profile Editing',style: TextStyle(color: Colors.white),),
      ),
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
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
              : Email != null
                  ? FutureBuilder<dynamic>(
                      future: FirebaseApi.getimage(Email!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        }
                        return const SizedBox(height: 100,width: 100, child:  CircularProgressIndicator());
                      })
                  : Image.network(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
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
              controller: phonenum,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'phonenumber '),
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
              
              if(file != null ){
                await uploadFile();
              }
              if(name != null){
                username = name?.value.text ?? '';
                FirebaseFirestore.instance.collection('users').doc(Email).set({  
                  'name': username
                 }, SetOptions(merge: true));
                   }
              if(location != null){
                loc = location?.value.text ?? 'location is not available';
                FirebaseFirestore.instance.collection('users').doc(Email).set({  
                   'location': loc,
                 }, SetOptions(merge: true));
                   }
              if(phonenum != null){
                phonenumber = phonenum?.value.text ?? '';
                FirebaseFirestore.instance.collection('users').doc(Email).set({  
                   'phonenumber': phonenumber
                 }, SetOptions(merge: true));
                   }
                   Sharedpreference.setuser(username, Email, loc, phonenumber);
                   showDialog(context: context, builder: (context) => AlertDialog(
                     title: const Text('Success'),
                     content: const Text('Profile updated'),
                     actions: <Widget>[
                       ElevatedButton(
                         onPressed: () {
                           Navigator.of(context).pop();
                         },
                         child: const Text('ok'),
                       )
                     ],
                   ));
              },
            
            child: const Text('Update'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
              fixedSize: MaterialStateProperty.all(const Size.fromWidth(180)),
            ),
          ),
        ],
      )
    ])));
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

  }
}
