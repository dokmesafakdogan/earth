import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth/screens/notifier/auth_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {

  Future<String> uploadImagetoStroge(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData(
      {required Uint8List file}) async{
        String resp  = "Some error occured";
        try{
          
          String imageUrl = await uploadImagetoStroge('ProfileImage', file);
          await _firestore.collection('users').doc(AuthManager.instance.userUuid).update({'imageUrl':imageUrl});
          resp = 'success';
          
        }catch(err){
          resp = err.toString();
        }
        return resp;
      }
}
