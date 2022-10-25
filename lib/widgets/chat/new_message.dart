import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var enteredString = '';

  final _message = TextEditingController();

  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    await FirebaseFirestore.instance.collection('chat').add({
      'text': enteredString,
      'createdAt': Timestamp.now(),
      'userId' : user.uid,
      'username': userData['username'],
      'userImage': userData['imageUrl']
    });
    _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _message,
              onChanged: (value) {
                setState(() {
                  enteredString = value;
                });
              },
              decoration: const InputDecoration(label: Text('Send message')),
            ),
          ),
          IconButton(
            onPressed: enteredString.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
