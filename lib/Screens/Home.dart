import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand/classes/Post.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:secondhand/classes/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/Users.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    super.initState();
    getemail();
  }

  int _selectedIndex = 0;
  final items = <Widget>[
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
      Icons.person,
      size: 20,
      color: Colors.white,
    ),
  ];
  final Storage storage = Storage();
  String? email;
  String? name = '';
  String? phonenumber = '';
  String? location = '';
  String? image = '';

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
  int? select;
  bool? type = true;

  Stream<List<Post>> readPosts() => FirebaseFirestore.instance
      .collection('post')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  Widget buildpost(Post post) => GestureDetector(
      onTap: () async {
        await getuser(post.email ?? '');
        opendialog();
      },
      child: Container(
          child: Column(
        children: [
          FutureBuilder(
              future: storage.downloadurl('${post.name}${post.email}'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (select == 1) {
                  if (post.catagory == 'Tech') {
                    type = true;
                  } else {
                    type = false;
                  }
                } else if (select == 2) {
                  if (post.catagory == 'Car') {
                    type = true;
                  } else {
                    type = false;
                  }
                } else if (select == 3) {
                  if (post.catagory == 'Furniture') {
                    type = true;
                  } else {
                    type = false;
                  }
                } else if (select == 4) {
                  if (post.catagory == 'Clothes') {
                    type = true;
                  } else {
                    type = false;
                  }
                } else {
                  type = true;
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    type!) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        width: 300,
                        height: 200,
                        child: Image.network(
                          snapshot.data ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('name:${post.name}'),
                            Text('price:${post.price}'),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Text('email:${post.email}'),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                          post.description ?? ' no description available',
                        ),
                        margin: EdgeInsets.all(20),
                      )
                    ],
                  );
                }
                return Text('');
              }),
        ],
      )));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,backgroundColor: Colors.cyan,
        title: const Text('Home',style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                selectedColor: Colors.cyan[500],
                backgroundColor: Colors.cyan[300],
                label: Text('Tech',style: TextStyle(color: Colors.white)),
                selected: select == 1 ? true : false,
                onSelected: (bool newValue) {
                  setState(() {
                    select = 1;
                  });
                },
              ),
              ChoiceChip(
                selectedColor: Colors.cyan[500],
                backgroundColor: Colors.cyan[300],
                label: Text('Car',style: TextStyle(color: Colors.white)),
                selected: select == 2 ? true : false,
                onSelected: (bool newValue) {
                  setState(() {
                    select = 2;
                  });
                },
              ),
              ChoiceChip(
                selectedColor: Colors.cyan[500],
                backgroundColor: Colors.cyan[300],
                label: Text('Furniture',style: TextStyle(color: Colors.white)),
                selected: select == 3 ? true : false,
                onSelected: (bool newValue) {
                  setState(() {
                    select = 3;
                  });
                },
              ),
              ChoiceChip(
                selectedColor: Colors.cyan[500],
                backgroundColor: Colors.cyan[300],
                label: Text('Clothes',style: TextStyle(color: Colors.white)),
                selected: select == 4 ? true : false,
                onSelected: (bool newValue) {
                  setState(() {
                    select = 4;
                  });
                },
              ),
            ],
          ),
          Expanded(
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
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        items: items,
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

  getuser(String email) async {
    var value =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    Users _user = Users.fromMap(value.data() as Map<String, dynamic>);
    name = _user.name;
    location = _user.location;
    phonenumber = _user.phonenumber;
    image = await firebase_storage.FirebaseStorage.instance
        .ref('users/$email')
        .getDownloadURL();
    setState(() {});
  }

  Future opendialog() => showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
          title: const Text(
            'Sellers profile',
            textAlign: TextAlign.center,
          ),
          content: Container(
            color: Colors.grey[300],
            width: 300,
            height: 400,
            child: Column(
              children: [
                ClipOval(
                  child: Image.network(
                    image ??
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  child: Text(name ?? 'no name',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center),
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                ),
                Container(
                  child: Text(
                    'location: lives in $location ',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                ),
                Container(
                  child: Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                ),
                Container(
                  child: Text(
                    'Phone number: $phonenumber',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                ),
              ],
            ),
          )));
}
