import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/Screens/Post.dart';
import 'package:secondhand/classes/firebaseapi.dart';
import 'package:path/path.dart';
import 'package:secondhand/classes/storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final Storage storage = Storage();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      Navigator.popAndPushNamed(this.context, '/post');
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

  UploadTask? task;
  File? file;
  String? url;

  Stream<List<Post>> readPosts() => FirebaseFirestore.instance
      .collection('post')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  Widget buildpost(Post post) => Column(
        children: [ FutureBuilder(
              future: storage.downloadurl('${post.name}${post.email}'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData == true) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    width: 300,
                    height: 200,
                    child: Image.network(snapshot.data??'',fit: BoxFit.cover ,),
                  );
                }
                return CircularProgressIndicator();
              }),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text('name:${post.name}'),
            Text('price:${post.price}'),
          ]),
          Text(post.description ?? ' no description available')
        ],
      );

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
      ),
      body: Center(
        child: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
              height: 550,
              child: StreamBuilder<List<Post>>(
                stream: readPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('erorr');
                  }
                  if (snapshot.hasData) {
                    final post = snapshot.data!;
                    return ListView(
                      
                      children: post.map(buildpost).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ))
        ]),
      ),
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'file$fileName';
    task = FirebaseApi.uploadFile(destination, file!);

    setState(() {});
  }
}
