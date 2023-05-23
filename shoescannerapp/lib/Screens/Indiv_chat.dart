import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../All_Data.dart';
import '../Layout/Colors.dart';
import 'Home_Page.dart';
import 'Login.dart';

class Indiv_chat extends StatefulWidget {
  static const String id = 'Indiv_chat';

  @override
  State<Indiv_chat> createState() => _Indiv_chatState();
}

class _Indiv_chatState extends State<Indiv_chat> {
  final _messageController = TextEditingController();
  final List<String> _messages = [];
  String firstName = '';
  String lastName = '';
  String email = '';
  String name = '';
  String chatID = '';
  String username = '';
  String timestID = '';
  late String _userId;
  late CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  void _getUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        firstName = user!.displayName!.split(" ")[0];
        lastName = user!.displayName!.split(" ")[1];
        email = user.email!;
        name = '$firstName $lastName';
        chatID = '$email $_userId';
        print(chatID);
        print(name);

        _messagesCollection = FirebaseFirestore.instance.collection('messages');
      });

      // Get user role from Firestore
      final userDat = await FirebaseFirestore.instance
          .collection('messages')
          .doc(email)
          .get();
      if (userDat.exists) {
        print('userDat exist');
        setState(() {
          chatID = userDat.data()?['chatID'] ?? '';
          username = userDat.data()?['name'] ?? '';
          timestID = userDat.data()?['timestamp'] ?? '';
        });
      }
    }
  }

// Retrieve messages based on user role
  Stream<QuerySnapshot> _getMessagesStream() {
    return _messagesCollection
        .orderBy('timestamp')
        .snapshots();
  }

  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      _messagesCollection.add({
        'chatID': chatID,
        'name': name,
        'email': email,
        'message': message,
        'timestamp': Timestamp.now(),
      });
      setState(() {
        _messages.add(message);
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Chat'),
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getMessagesStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages =
                    snapshot.data!.docs.map((doc) => doc['message']).toList();
                final username =
                    snapshot.data!.docs.map((doc) => doc['name']).toList();
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = messages[index];
                    return ListTile(
                        title: Text(message),
                        trailing: Text(username[index]));
                  },
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter a message...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
