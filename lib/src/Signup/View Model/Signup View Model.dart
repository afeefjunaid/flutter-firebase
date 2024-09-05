import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class signupViewModel{
  var inst=FirebaseFirestore.instance.collection("Users");
  addUser(String name, String email,String pass) async {
    inst.add({
      'name':name,
      'email':email,
      'password':pass,
      'uid':FirebaseAuth.instance.currentUser?.uid,
      'deviceToken':await FirebaseMessaging.instance.getToken()
    });
  }
}