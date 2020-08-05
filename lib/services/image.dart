import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  static Future<dynamic> getImageUrl({uid: String, imageKey: String}) {
    return FirebaseStorage().ref().child('/$uid/$imageKey}').getDownloadURL();
  }
}
