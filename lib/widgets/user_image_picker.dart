import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:earth/widgets/add_data.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(String photoURL) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  double screenHeight = 0;
  double screenWidth = 0;

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    // print('no image is selected');
  }

  Uint8List? _image;
  late String _imageUrl = 'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png'; // Initialize with a default image URL

  @override
  void initState() {
    super.initState();
    fetchImageUrl();
  }

  Future<void> fetchImageUrl() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final data = snapshot.data();
        setState(() {
          _imageUrl = data?['imageUrl'] ?? _imageUrl;
        });
      } else {
       
      }
    } catch (e) {
      // Handle errors
    // print("Error fetching image URL: $e");
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveAvatar() async {
    // ignore: unused_local_variable
    String resp = await StoreData().saveData(file: _image!);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture changed.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
             _image != null ?
          CircleAvatar(
            radius: 64,
            backgroundImage:  MemoryImage(_image!),
          ):
             CircleAvatar(
              radius: 64,
              backgroundImage:  
              NetworkImage(_imageUrl)
            ),
            // CircleAvatar(
            //   radius: 64,
            //   backgroundImage: _image != null ? MemoryImage(_image!) : NetworkImage(_imageUrl),
            // ),
            Positioned(
              bottom: -10,
              left: 80,
              child: IconButton(
                onPressed: selectImage,
                icon: const Icon(Icons.add_a_photo),
              ),
            )
          ],
        ),
        ElevatedButton(onPressed: saveAvatar, child: const Text('Save'))
      ],
    );
  }
}
