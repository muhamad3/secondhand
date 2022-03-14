import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondhand/classes/Post.dart';
import 'package:secondhand/classes/sharedpreferences.dart';
import 'package:secondhand/classes/storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:secondhand/classes/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SellersProfile extends StatefulWidget {
  const SellersProfile({Key? key}) : super(key: key);

  @override
  _SellersProfile createState() => _SellersProfile();
}

class _SellersProfile extends State<SellersProfile> {
  @override
  void initState() {
    super.initState();
    // to get the sellers info
    // to get the users info
    // and  to know if the collection exists
    //and to know if they talked before
    getuser();

    setState(() {});
  }

  String? image;
  String? sellername;
  String? usersname;
  String? sellersemail;
  String? usersemail;
  String? location;
  String? phonenumber;
  bool exists = false;
  final Storage storage = Storage();

  //for the seller info
  Future getuser() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    sellersemail = preference.getString('sellersemail');
    // to get the user's name
    usersemail = preference.getString('name');

    //to get the seller's profile image
    image = await firebase_storage.FirebaseStorage.instance
        .ref('users/$sellersemail')
        .getDownloadURL();
    //to get the sellers information
    var value = await FirebaseFirestore.instance
        .collection('users')
        .doc(sellersemail)
        .get();
    Users _user = Users.fromMap(value.data() as Map<String, dynamic>);
    sellername = _user.name;
    phonenumber = _user.phonenumber;
    location = _user.location;

    //for the users info
    usersemail = preference.getString('email');

    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(usersemail)
        .collection("$usersemail's chats")
        .doc(sellersemail)
        .get();
    if (snapshot.exists) {
      exists = true;
    }

    final reverse = await FirebaseFirestore.instance
        .collection('messeges')
        .doc(sellersemail)
        .collection('$sellersemail to $usersemail')
        .doc(usersemail)
        .get();
    if (reverse.exists) {
      Sharedpreference.revrsetalked(true);
    } else {
      Sharedpreference.revrsetalked(false);
    }
    setState(() {});
  }

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
                    post.email == sellersemail) {
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
                      Text(post.description ?? ' no description available'),
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: const Text(
          "Seller's Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Stack(children: <Widget>[
            Column(children: [
              const SizedBox(
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
                child: Text(sellername ?? 'no name',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              ),
              Container(
                child: Text(
                  'location: lives in $location ',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              Container(
                child: Text(
                  'Email: $sellersemail',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              Container(
                child: Text(
                  'Phone number: $phonenumber',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              !(sellersemail == usersemail)
                  ? ElevatedButton(
                      onPressed: () {
                        DateTime time = DateTime.now();
                        if (!exists) {
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(usersemail)
                              .collection("$usersemail's chats")
                              .doc(sellersemail)
                              .set({
                            'name': sellername,
                            'email': sellersemail,
                            'time': time
                          });

                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(sellersemail)
                              .collection("$sellersemail's chats")
                              .doc(usersemail)
                              .set({
                            'name': usersname,
                            'email': usersemail,
                            'time': time
                          });

                          FirebaseFirestore.instance
                              .collection('messeges')
                              .doc(usersemail)
                              .collection('$usersemail to $sellersemail')
                              .doc(sellersemail)
                              .set({
                            'messege': '',
                            'time': time,
                            'email': usersemail
                          });
                        }

                        Navigator.pushNamed(context, '/chat');
                      },
                      child: const Text('send a messege'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.cyan),
                        fixedSize: MaterialStateProperty.all(
                            const Size.fromWidth(180)),
                      ),
                    )
                  : const Text(''),
              const Divider(
                color: Colors.black,
              ),
              Text(
                "$sellername's posts",
                style: const TextStyle(fontSize: 20),
              ),
              SizedBox(
                  height: 450,
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
      ]),
    );
  }
}
