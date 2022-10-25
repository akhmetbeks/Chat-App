import 'package:chat_app/widgets/chat/new_message.dart';

import '../widgets/chat/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print('handling a background message: ${message.messageId}');
}

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final firebaseMessage = FirebaseMessaging.instance;
    firebaseMessage.subscribeToTopic('chat');

    FirebaseMessaging.onMessage.listen((event) {
      print('message received');
      print('${event.notification!.body}');
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.exit_to_app_rounded))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            const Expanded(
              child: Messages(),
            ),
            NewMessage()
          ],
        ),
      ),
    );
  }
}
