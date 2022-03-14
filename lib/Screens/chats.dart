import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/classes/chatsdatamodel.dart';
import 'package:secondhand/classes/sharedpreferences.dart';
import 'package:secondhand/classes/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    super.initState();
    getemail();
    setState(() {});
  }

  String? useremail;
  getemail() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    useremail = preference.getString('email');
    setState(() {});
  }

  final items = <Widget>[
    const Icon(
      Icons.home,
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
      size: 20,
      color: Colors.white,
    ),
    const Icon(
      Icons.person,
      size: 20,
      color: Colors.white,
    ),
  ];
  final Storage storage = Storage();
  int _selectedIndex = 2;
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
    if (_selectedIndex == 2) {
      Navigator.popAndPushNamed(context, '/chats');
    }
    if (_selectedIndex == 3) {
      Navigator.popAndPushNamed(context, '/profile');
    }
  }

  Stream<List<Chatsdata>> readPosts() => FirebaseFirestore.instance
      .collection('chats')
      .doc(useremail)
      .collection("$useremail's chats")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Chatsdata.fromJson(doc.data())).toList());

  Widget buildpost(Chatsdata chatsdata) => Column(
        children: [
          FutureBuilder(
              future: storage.downloadurlchats(chatsdata.email!),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return GestureDetector(
                    onTap: (() async {
                      Sharedpreference.sellersemail(chatsdata.email);
                      final snap = await FirebaseFirestore.instance
                          .collection('messeges')
                          .doc(chatsdata.email)
                          .collection('${chatsdata.email} to $useremail')
                          .doc(useremail)
                          .get();
                      if (snap.exists) {
                        Sharedpreference.revrsetalked(true);
                      } else {
                        Sharedpreference.revrsetalked(false);
                      }
                      Navigator.pushNamed(context, '/chat');
                    }),
                    child: ListTile(
                      title: Text(chatsdata.name ?? ''),
                      leading: ClipOval(
                        child: Image.network(
                          snapshot.data ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      subtitle: Text(chatsdata.email ?? ''),
                    ),
                  );
                }
                return const Text('');
              }),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Expanded(
              child: StreamBuilder<List<Chatsdata>>(
            stream: readPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('erorr');
              }
              if (snapshot.hasData) {
                final chatsdata = snapshot.data!;
                return ListView(
                  children: chatsdata.map(buildpost).toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ))
        ],
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
}
