import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
late User signedUser;

class ChatScreen extends StatefulWidget {
  static const String routeScreen = 'chatscreen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedUser = user;
        print(signedUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   await for (var snapshot in _firestore.collection("users").snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset(
              'images/360_F_511873784_NLmIMOcuwo9JTuoXJNyR0jQSQOUXUvFk.jpg',
              height: 50,
            ),
            Text(
              "Message Me",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            messageStreamBilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Write your message here...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10)),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        messageController.clear();
                        _firestore.collection("messages").add({
                          'sender': signedUser.email,
                          'text': messageText,
                          'time': FieldValue.serverTimestamp()
                        });
                      },
                      child: Text(
                        "send",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class messageStreamBilder extends StatelessWidget {
  const messageStreamBilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection("messages").orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messageWedgits = [];
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final messageText = message.get("text");
            final messageSender = message.get("sender");
            final currentUser = signedUser.email;

            final messageWedgit = MessageLine(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            messageWedgits.add(messageWedgit);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              children: messageWedgits,
            ),
          );
        });
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({super.key, required this.isMe, this.sender, this.text});
  final String? sender;
  final String? text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
          ),
          Material(
              elevation: 5,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              color: isMe ? Colors.blue[800] : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 15,
                      color: isMe ? Colors.white : Colors.black45),
                ),
              )),
        ],
      ),
    );
  }
}
