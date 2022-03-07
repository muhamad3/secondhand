import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/classes/firebaseapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Posting extends StatefulWidget {
  const Posting({Key? key}) : super(key: key);

  @override
  _Posting createState() => _Posting();
}

class _Posting extends State<Posting> {
  @override
  void initState() {
    super.initState();
    getemail();
  }
    final item = <Widget>[
    Icon(
      Icons.home,
      size: 30,
      color: Colors.white,
    ),
    Icon(
      Icons.add_box,
      color: Colors.white,
      size: 30,
    ),
    Icon(
      Icons.chat,
      color: Colors.white,
      size: 30,
    ),
    Icon(
      Icons.person,
      size: 20,
      color: Colors.white,
    ),
  ];
  int _selectedIndex = 1;
  int _value = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.popAndPushNamed(this.context, '/home');
    }
    if (_selectedIndex == 2) {
      Navigator.popAndPushNamed(this.context, '/chat');
    }
    if (_selectedIndex == 3) {
      Navigator.popAndPushNamed(this.context, '/profile');
    }
  }

  Future pickimage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => file = imageTemporary);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final destination = 'post/$Name$email';
    task = FirebaseApi.uploadFile(destination, file!);

    setState(() {});
  }

  UploadTask? task;
  File? file;

  TextEditingController? name = TextEditingController();
  TextEditingController? price = TextEditingController();
  TextEditingController? descrioption = TextEditingController();
  String Name = '';
  String? Price = '0';
  String? Descrioption;
  String? email;
  String dropdownvalue = 'Tech';

  var items = [
    'Clothes',
    'Tech',
    'Car',
    'Furniture',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,backgroundColor: Colors.cyan,
        title: const Text('Posting',style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Column(children: [
              Container(
                child: file != null
                    ? ClipOval(
                        child: Image.file(
                          file!,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.network(
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                      ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.cyan),
                  ),
                  onPressed: () {
                    pickimage();
                    selectFile();
                  },
                  child: const Text('pick an image from gallery')),
              Container(
                child: TextField(
                  controller: name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'The name of the item'),
                ),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              ),
              Container(
                child: TextField(
                  controller: price,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'the price'),
                  keyboardType: TextInputType.number,
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              ),
              Row(children: [
                Text('       Currency :'),
                Radio(
                    value: 1,
                    groupValue: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = int.parse(value.toString());
                      });
                    }),
                Text('USD'),
                Radio(
                    value: 2,
                    groupValue: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = int.parse(value.toString());
                      });
                    }),
                Text('IQD'),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Catagory :   '),
                  DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Container(
                child: TextField(
                  controller: descrioption,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'description'),
                  maxLines: 5,
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              ),
              ElevatedButton(
                onPressed: () {
                  Name = name?.value.text ?? 'no name avialable';
                  Price = price?.value.text ?? 'no price available';
                  if (_value == 1) {
                    Price = "$Price" r" $";
                  } else if (_value == 2) {
                    Price = "$Price IQD";
                  }
                  Descrioption =
                      descrioption?.value.text ?? 'no description available';
                  FirebaseFirestore.instance
                      .collection('post')
                      .doc(email! + Name)
                      .set({
                    'Name': Name,
                    'Price': Price,
                    'Description': Descrioption,
                    'Email': email,
                    'catagory': dropdownvalue
                  });

                  uploadFile();
                  Navigator.popAndPushNamed(context, '/post');
                },
                child: const Text('Post'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan),
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromWidth(180)),
                ),
              ),
            ]),
          ]),
        ),
      ),
          bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        items: item,
        backgroundColor: Colors.transparent,
        color: Colors.cyan,
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  getemail() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    email = preference.getString('email');
    setState(() {});
  }
}
