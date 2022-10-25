import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_from.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  var isLoading = false;

  void _submitAuthForm(
    String userName,
    String userEmail,
    String userPassword,
    File image,
    bool isLogin,
  ) async {
    UserCredential userCred;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        userCred = await _auth.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);
      } else {
        userCred = await _auth.createUserWithEmailAndPassword(
            email: userEmail, password: userPassword);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(userCred.user!.uid + '.jpg');

        ref.putFile(image).whenComplete(() async {
          final url = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCred.user!.uid)
              .set({'username': userName, 'email': userEmail, 'imageUrl': url});
        });
      }
    } on FirebaseAuthException catch (err) {
      var message = 'check credentials';

      if (err.message != null) {
        message = err.message!;
      }

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ));

      setState(() {
        isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, isLoading),
    );
  }
}
