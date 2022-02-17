import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<firebase_storage.ListResult> listfile() async {
    firebase_storage.ListResult result = await storage.ref('post').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print('found files $ref');
    });
    return result;
  }

  Future<String> downloadurl(String image) async {
    String downloadurl = await storage.ref('post/$image').getDownloadURL();
    return downloadurl;
  }
}
