import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      print('point 1');

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  
  
}
