import 'package:chat_app/widgets/pickers/image_upload.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String userName,
    String userEmail,
    String userPassword,
    File image,
    bool isLogin,
  ) submitFn;

  AuthForm(this.submitFn, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _usrImage;

  void _pickedImage(File _img) {
    _usrImage = _img;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (_usrImage == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pick an Image')));
      return;
    }

    if (isValid == true) {
      _formKey.currentState!.save();
    }
    widget.submitFn(
      _userName,
      _userEmail,
      _userPassword,
      _usrImage!,
      isLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLogin) ImageUpload(_pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email address'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Username must be at least 5 characters long';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? 'Create new account'
                            : 'I already have an account',
                        style: const TextStyle(color: Colors.pink),
                      ),
                    )
                ],
              )),
        ),
      ),
    );
  }
}
