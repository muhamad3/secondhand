import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    getemail();
    setState(() {});
  }

  String? email;
  TextEditingController msg = TextEditingController();
  int _selectedIndex = 2;
  String? test;
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
      Navigator.popAndPushNamed(context, '/chat');
    }
    if (_selectedIndex == 3) {
      Navigator.popAndPushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'chating screen',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // margin: EdgeInsets.all(20),
              height: 150,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messeges')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('the type is empty');
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    List<DocumentSnapshot> _docs = snapshot.data!.docs;

                    List _users = _docs.map((e) => e["messege"]).toList();
                    List _emails = _docs.map((e) => e["email"]).toList();
                    List _time = _docs.map((e) => e["time"]).toList();

                    return ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                            DateTime time = DateTime.parse(
                                _time[index].toDate().toString());
                            String formattedTime = DateFormat.jm().format(time);  
                          if (email == _emails[index]) {
                            return BubbleSpecialThree(
                              isSender: true,
                              text: '${_users[index]}$formattedTime',
                              color: Color(0xFF1B97F3),
                              tail: true,
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            );
                          }
                          return BubbleSpecialThree(
                            isSender: false,
                            text: '${_users[index]}$formattedTime',
                            color: Colors.grey,
                            tail: true,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
                          );
                        });
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msg,
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime time = DateTime.now();
                      await FirebaseFirestore.instance
                          .collection('messeges')
                          .add({
                        'messege': msg.value.text,
                        'email': email,
                        'time': time,
                      }).catchError((e) => debugPrint(e.toString()));
                    },
                    child: Text("send"),
                  ),
                ),
              ],
            ),
          ),
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

  getemail() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    email = preference.getString('email');
  }
}
