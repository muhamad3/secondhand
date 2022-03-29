import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException {
      
      return null;
    }
  }
  static getimage(String email) async {
    final image = await firebase_storage.FirebaseStorage.instance
        .ref('users/$email')
        .getDownloadURL();
    return image;
  }
  
  
}
