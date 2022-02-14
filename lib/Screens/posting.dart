import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/Screens/firebaseapi.dart';
import 'package:path/path.dart';

class Posting extends StatefulWidget {
  const Posting({Key? key}) : super(key: key);

  @override
  _Posting createState() => _Posting();
}

class _Posting extends State<Posting> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.popAndPushNamed(this.context, '/home');
    }
    if (_selectedIndex == 2) {
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
    uploadFile();
  }
    Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'post/$fileName';
    task = FirebaseApi.uploadFile(destination, file!);
  
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  UploadTask? task;
  File? file;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('posting'),
      ),
      body: Center(
        child:  Column(children: [
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
                  : Container(
                    child:FlutterLogo(size: 100,),
                    margin: EdgeInsets.all(10),
                    ),
                    
                  ),
          ElevatedButton(
              onPressed: () {
                pickimage();
                selectFile();
              },
              child: Text('pick an image from gallery')),
          
        ]),),
      
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
}
