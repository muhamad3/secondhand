import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:secondhand/classes/Post.dart';
import 'package:secondhand/classes/drawer.dart';
import 'package:secondhand/classes/storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getemail();
    getname();
    getlocation();
    getphonenumber();
    downloadurl();
  }

  int _selectedIndex = 2;
  String? test;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.popAndPushNamed(context, '/home');
    }
    if (_selectedIndex == 1) {
      Navigator.popAndPushNamed(context, '/post');
    }
  }

  String? image;
  String? name;
  String? email;
  String? location;
  String? phonenumber;
  final Storage storage = Storage();

  Stream<List<Post>> readPosts() => FirebaseFirestore.instance
      .collection('post')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  Widget buildpost(Post post) => Column(
        children: [
          FutureBuilder(
              future: storage.downloadurl('${post.name}${post.email}'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    post.email == email) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Column(children: [
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
                      Text(post.description ?? ' no description available'),
                      ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('post')
                                .doc(post.email! + post.name!)
                                .delete();
                            FirebaseStorage.instance
                                .ref('post/${post.name}${post.email}')
                                .delete();
                          },
                          child: Text('delete this post'))
                    ]),
                  );
                }
                return Text('');
              }),
        ],
      );
  downloadurl() async {
    image = await firebase_storage.FirebaseStorage.
    instance.ref('users/hama@gmail.com').getDownloadURL();
    setState(() {
      
    });
    print('===================================>$image');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
      drawer: NavigationDrawerWidget(),
      body: Stack(children: <Widget>[
        Center(
          child: SingleChildScrollView(
            child: Stack(children: <Widget>[
              Column(children: [
                SizedBox(
                  height: 25,
                ),
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
                Divider(
                  color: Colors.black,
                ),
                Text(
                  'your posts',
                  style: TextStyle(fontSize: 20),
                ),
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
            ]),
          ),
        ),
      ]),
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

  getname() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    name = preference.getString('name');
  }

  getemail() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    email = preference.getString('email');
    setState(() {});
  }

  getlocation() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    location = preference.getString('location');
  }

  getphonenumber() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    phonenumber = preference.getString('phonenumber');
  }
}
