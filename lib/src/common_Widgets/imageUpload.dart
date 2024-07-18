import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';



pickImage(ImageSource source) async {
  final ImagePicker image = ImagePicker();
  XFile? file = await image.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  else{
    print("No Image is Selected");
  }
}


class uploadImage {

  static Future<String> uploadImageToFirebase(String filename, Uint8List file) async {
    Reference ref = FirebaseStorage.instance.ref().child(filename);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }




}