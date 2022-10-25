import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String username;
  final String imageUrl;
  final bool isMe;
  final Key key;

  MessageBubble(this.message, this.isMe, this.username, this.imageUrl,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return 
    Stack(children: [
      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.deepPurple : Colors.deepOrange[400],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            width: 150,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(
        top: 0,
        left: isMe ? null : 140,
        right: isMe ? 140 : null,
        child: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      )
    ]);
  }
}
