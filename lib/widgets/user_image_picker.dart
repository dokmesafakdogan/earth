import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(String photoURL) onPickImage;

 @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
    
  }
}  

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    final pickedImage = await  ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _isLoading = false;
    });

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    _uploadImageToFirebase();
  }

  // Future<void> _uploadImageToFirebase() async {
  //   if (_pickedImageFile == null) return;

  //   final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   final firebaseStorageRef =
  //       firebase_storage.FirebaseStorage.instance.ref().child(fileName);

  //   await firebaseStorageRef.putFile(_pickedImageFile!);

  //   final photoURL = await firebaseStorageRef.getDownloadURL();

  //   widget.onPickImage(photoURL);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedImageFile != null
              ? FileImage(_pickedImageFile!)
              : null,
          child: _isLoading ? const CircularProgressIndicator() : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text(
            'Add Image',
          ),
        ),
      ],
    );
  }
}
