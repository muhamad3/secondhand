import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<firebase_storage.ListResult> listfile() async {
    firebase_storage.ListResult result = await storage.ref('post').listAll();
    return result;
  }

  Future<String> downloadurl(String image) async {
    String downloadurl = await storage.ref('post/$image').getDownloadURL();
    return downloadurl;
  }
  Future<String> downloadurlchats(String image) async {
    String downloadurl = await storage.ref('users/$image').getDownloadURL();
    return downloadurl;
  }
}
