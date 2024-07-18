import 'dart:typed_data';
import 'package:adminpanel/src/common_Widgets/imageUpload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Clients {
  final CollectionReference clientInstance =
  FirebaseFirestore.instance.collection("Clients");

  late String name;
  late String email;
  late bool isClientVerified;
  late bool isClientDisabled;
  late String password;
  late String imageURL;
  late String uid;

  Clients({
    this.email = '',
    this.name = '',
    this.password = '',
    this.isClientDisabled = false,
    this.isClientVerified = false,
    this.imageURL = '',
    this.uid=''
  });

  static Clients fromDocument(DocumentSnapshot snap) {
    Map<String, dynamic> doc = snap.data() as Map<String, dynamic>;
    return Clients(
      name: doc['name'],
      email: doc['email'],
      password: doc["password"],
      isClientDisabled: doc['isDisabled'] ?? false,
      isClientVerified: doc['isVerified'] ?? false,
      imageURL: doc["imageURL"] ?? '',
      uid: doc["uid"]
    );
  }

  Future<void> deleteData(String docId) async {
    await clientInstance.doc(docId).delete();
  }

  Future<void>toggleClient(bool toggle,String id)async {
    await clientInstance.doc(id).update({
      "isDisabled":toggle
    });
  }

  Future<String> updateData(
      String name, Uint8List file, String id) async {
    String response = "Some Error Occurred";
    if (name.isNotEmpty) {
      try {
        imageURL = await uploadImage.uploadImageToFirebase(name, file);
        await clientInstance.doc(id).update({
          "name": name,
          "imageURL": imageURL,
          "isDisabled": false,
          "isVerified": false,
        });
        response = "Success";
      } catch (err) {
        response = err.toString();
      }
    }
    return response;
  }

  Future<String> saveData(
      String name, String em, String pass, Uint8List file, String id) async {
    String response = "Some Error Occurred";
    if (name.isNotEmpty && em.isNotEmpty && pass.isNotEmpty) {
      try {
        imageURL = await uploadImage.uploadImageToFirebase(em, file);
        await clientInstance.add({
          "name": name,
          "email": em,
          "password": pass,
          "imageURL": imageURL,
          "isDisabled": false,
          "isVerified": false,
          "uid": id
        });
        response = "Success";
      } catch (err) {
        response = err.toString();
      }
    }
    return response;
  }
}
