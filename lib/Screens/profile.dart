import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:secondhand/classes/Post.dart';
import 'package:secondhand/classes/drawer.dart';
import 'package:secondhand/classes/scrolltohide.dart';
import 'package:secondhand/classes/storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_local_localizations.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    // to get email and name and location and phone number and image of user
    getemail();
    controller = ScrollController();
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }


  int _selectedIndex = 4;
  String? test;
    final items = <Widget>[
    const Icon(
      Icons.home,
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      Icons.search,
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      Icons.add_box,
      color: Colors.white,
      size: 30,
    ),
    const Icon(
      Icons.chat,
      color: Colors.white,
      size: 30,
    ),
    const Icon(
      Icons.person,
      size: 20,
      color: Colors.white,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.popAndPushNamed(context, '/home');
    }
    if (_selectedIndex == 1) {
      Navigator.popAndPushNamed(context, '/search');
    }
    if (_selectedIndex == 2) {
      Navigator.popAndPushNamed(context, '/post');
    }
    if (_selectedIndex == 3) {
      Navigator.popAndPushNamed(context, '/chats');
    }
    if (_selectedIndex == 4) {
      Navigator.popAndPushNamed(context, '/profile');
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
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                      Text(post.description ?? ''),
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
                          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
          ),
                          child: const Text('delete this post'))
                    ]),
                  );
                }
                return const SizedBox.shrink();
              }),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,backgroundColor: Colors.cyan,
        title: const Text('Profile',style: TextStyle(color: Colors.white),),
      ),
      drawer: const NavigationDrawerWidget(),
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Stack(children: <Widget>[
            Column(
              children: [
                ScrollToDideWideget(
                  controller: controller,
                  child:  Column(
                      children:[
                               SizedBox(
                                child: Text(AppLocalizations.of(context)!.language
                                ),
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
                    child: Text(name ?? 'please wait',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center),
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                              ),
                              Container(
                    child: Text(location !=null?
                      'location: lives in $location':'',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              ),
                              Container(
                    child: Text(email != null ?
                      'Email: $email':'',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              ),
                              Container(
                    child: Text(phonenumber != null?
                      'Phone number: $phonenumber':'',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              ),
                              const Divider(
                    color: Colors.black,
                              ),
                              const Text(
                    'your posts',
                    style:  TextStyle(fontSize: 20),
                              ),]
                  ),
                ),
              SizedBox(
                  height: 700,
                  child: StreamBuilder<List<Post>>(
                    stream: readPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('erorr');
                      }
                      if (snapshot.hasData) {
                        final post = snapshot.data!;
                        return ListView(
                          controller: controller,
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
      ]),
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
    name = preference.getString('name');
    phonenumber = preference.getString('phonenumber');
    location = preference.getString('location');
    image = await firebase_storage.FirebaseStorage.instance
        .ref('users/$email')
        .getDownloadURL();
    setState(() {});
  }

}
