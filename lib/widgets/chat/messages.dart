import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (ctx, i) {
              return MessageBubble(docs[i]['text'],
                  docs[i]['userId'] == FirebaseAuth.instance.currentUser!.uid,
                  docs[i]['username'],
                  docs[i]['userImage'],
                  key: ValueKey(docs[i].id));
            });
      },
    );
  }
}
