import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  String? profilePicLink;

  Future<void> pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    if (image == null) return;

    final Reference ref = FirebaseStorage.instance.ref().child("profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg");

    final UploadTask uploadTask = ref.putFile(File(image.path));

    uploadTask.whenComplete(() async {
      try {
        final String photoURL = await ref.getDownloadURL();
        setState(() {
          profilePicLink = photoURL;
        });
        widget.onPickImage(profilePicLink!);
      } catch (e) {
        print("Error uploading profile picture: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: pickUploadProfilePic,
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              height: 300,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: profilePicLink == null
                    ? const Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 116, 14, 14),
                        size: 80,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(profilePicLink!),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
