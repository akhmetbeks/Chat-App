import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  ImageUpload(this._imagePickFn);

  final void Function(File pickedImage) _imagePickFn;

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _pickedImage;

  void _pickImage() async {
    var _picker = ImagePicker();
    var _pickFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage = File(_pickFile!.path);
    });
    widget._imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueGrey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Upload an image'),
        ),
      ],
    );
  }
}
