import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth/screens/after%20sign/password_change.dart';
import 'package:earth/screens/before%20sign/sign_screen.dart';
import 'package:earth/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({Key? key}) : super(key: key);

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  UserResponseModel? userResponse;
  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snapshot.data();
      if (snapshot.exists) {
        setState(() {
          userResponse = UserResponseModel.fromJson(data!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ' ${userResponse?.name} ${userResponse?.surname}',
                  style: const TextStyle(fontSize: 34),
                ),
                const Text('View and edit your profile'),
                UserImagePicker(onPickImage: (photoURL) {
                  setState(() {
                  userResponse?.photoURL = photoURL;
                });
                })
              ],
            
          ),
          const SizedBox(
            height: 200,
          ),
        
              GestureDetector(
                child: const  Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 34),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Change Password',style: TextStyle(fontSize: 23),),
                     Icon(Icons.lock_open)],
                  ),
                ),onLongPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePasswordScreen(),));
                },
              ),
              const Divider(color:Colors.black,endIndent: 23,indent: 23,),
              const SizedBox(height: 12,),
             GestureDetector(
               child: const Padding(
                 padding:  EdgeInsets.symmetric(horizontal:34.0),
                 child:   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Setting',style: TextStyle(fontSize: 23),),
                      Icon(Icons.settings)
                    ],
                  ),
               ),
               onLongPress: () {
                 
               },
             ),
                const Divider(color:Colors.black,endIndent: 23,indent: 23,),
            
          
        ],
      ),
    );
  }
}
