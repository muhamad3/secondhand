import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:secondhand/classes/firebaseapi.dart';
import 'package:secondhand/classes/sharedpreferences.dart';
import 'package:secondhand/classes/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
    getemail();
    setState(() {});
  }

  String? useremail;
  String? image;
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
      Icons.search,
      color: Colors.white,
      size: 30,
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
  int _selectedIndex = 1;
  String? name;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
            child: TextField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'search...'),
          onChanged: (val) {
            setState(() {
              name = val;
            });
          },
        )),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];
                      if (name != null
                          ? data['name'].substring(0, name!.length) == name
                          : true) {
                        return Column(
                          children: [
                            GestureDetector(
      onTap: () async {
        Sharedpreference.sellersemail(data['email']);
        Navigator.pushNamed(context, '/sellersprofile');
      },
      child: ListTile(
                              title: Text(
                                data['name'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              leading: ClipOval(
                                child: FutureBuilder<dynamic>(
  future: FirebaseApi.getimage(data['email']),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Image.network(
          snapshot.data!,height: 50,width: 50,fit: BoxFit.cover,
      );
    }
    return const CircularProgressIndicator();
  }
),
                              ),
                               )   )
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    });
          }),
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
