import 'package:cloud_firestore/cloud_firestore.dart';
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
    getusersemail();
    setState(() {});
  }

  getusersemail() async {
    final SharedPreferences preference = await SharedPreferences.getInstance();
    usersemail = preference.getString('email');
    sellersemail = preference.getString('sellersemail');
    reverse = preference.getBool('talked') ?? false;

    setState(() {});
  }

  final ScrollController _controller = ScrollController();
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
    );
  }

  String? usersemail;
  String? sellersemail;
  TextEditingController msg = TextEditingController();
  bool reverse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'chating screen',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 150,
              child: StreamBuilder<QuerySnapshot>(
                stream: reverse
                    ? FirebaseFirestore.instance
                        .collection('messeges')
                        .doc(sellersemail)
                        .collection('$sellersemail to $usersemail')
                        .orderBy('time', descending: false)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('messeges')
                        .doc(usersemail)
                        .collection('$usersemail to $sellersemail')
                        .orderBy('time', descending: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('error');
                  } //to get the messeges if the other user sent the messeges
                  else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('please wait');
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    List<DocumentSnapshot> _docs = snapshot.data!.docs;
                    List _users = _docs.map((e) => e["messege"]).toList();
                    List _emails = _docs.map((e) => e["email"]).toList();
                    List _time = _docs.map((e) => e["time"]).toList();

                    return ListView.builder(
                        controller: _controller,
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          //to show only hours and minutes from time stamp
                          DateTime time =
                              DateTime.parse(_time[index].toDate().toString());
                          String formattedTime = DateFormat.jm().format(time);
                          if (_users[index] != '') {
                            if (usersemail == _emails[index]) {
                              return BubbleSpecialThree(
                                isSender: true,
                                text: '${_users[index]}  $formattedTime',
                                color: Colors.cyan,
                                tail: true,
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              );
                            }
                            return BubbleSpecialThree(
                              isSender: false,
                              text: '${_users[index]}  $formattedTime',
                              color: Colors.grey,
                              tail: true,
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            );
                          }
                          return const SizedBox.shrink();
                        });
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msg,
                    decoration: const InputDecoration(
                        hintText: 'Type your messege here'),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      String messege = msg.value.text.trim();
                      msg.clear();
                      if (messege != '') {
                        DateTime time = DateTime.now();
                        if (!reverse) {
                          await FirebaseFirestore.instance
                              .collection('messeges')
                              .doc(usersemail)
                              .collection('$usersemail to $sellersemail')
                              .add({
                            'messege': messege,
                            'email': usersemail,
                            'time': time,
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection('messeges')
                              .doc(sellersemail)
                              .collection('$sellersemail to $usersemail')
                              .add({
                            'messege': messege,
                            'email': usersemail,
                            'time': time,
                          });
                        }
                      }
                      _scrollDown();
                    },
                    child: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
