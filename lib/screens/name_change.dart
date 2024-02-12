import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth/screens/before%20sign/sign_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NameChange extends StatefulWidget{
  const NameChange({super.key});

  @override
  State<NameChange> createState() => _NameChangeState();
}

class _NameChangeState extends State<NameChange> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
   final _formKey = GlobalKey<FormState>();
    
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

  Future<void> _updateSurnameName()async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      try{
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({ 
          'name' : _nameController.text,
          'surname' : _surnameController.text,
         });
         // ignore: use_build_context_synchronously
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('The changes were made successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                child:const  Text('OK'),
              ),
            ],
          ),
          
        );
      } catch(error){
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error accurred')));

      }
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      
      body:  Form(
        
        child: Column(
          key: _formKey,
          children: [ 
            const SizedBox(height: 50),
           const  Text('You can change your name and surname here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),),
            const SizedBox(height: 34,),
            const Text('Your name'),
             Text(
                  ' ${userResponse?.name} ${userResponse?.surname}',
                  style: const TextStyle(fontSize: 34),
                ),
            const SizedBox(height: 70,),
            Padding(
              padding: const  EdgeInsets.symmetric(horizontal: 30),
              child: 
              TextFormField(
                
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Name'),
                    controller: _nameController,
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please make sure yo write your name.';
                  }
                  return null;
                   })
            ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Surname'),
                    controller: _surnameController,
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please make sure yo write your surname.';
                  }
                  return null;
                   }),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  onPressed: _updateSurnameName,
                   child: const Text('Change')),
              ))
        
          ],
        ),
      ),
    );
  }
}