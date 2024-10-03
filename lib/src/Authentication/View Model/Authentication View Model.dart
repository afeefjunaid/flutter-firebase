import 'package:chatapp/src/Common%20Widgets/View/Common%20Widgets%20View.dart';
import 'package:chatapp/src/Login/View/Login%20View.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
var authInst=FirebaseAuth.instance;
var dbInst=FirebaseFirestore.instance.collection("Users");
class authenticationViewModel{


  Future<bool> signup(BuildContext context,String email, String pass)async {
    try{
      await authInst.createUserWithEmailAndPassword(email: email, password: pass);

      snackBarWidget("Signup Successful");
      return true;
    }
    on FirebaseAuthException catch(e){
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else {
        message = e.message ?? 'An error occurred. Please try again.';
      }
      snackBarWidget(message);
      return false;
    }
  }

  var chk;

Future<bool> login(String email,String pass) async {
  String? deviceToken = await FirebaseMessaging.instance.getToken();
    try {
      await authInst.signInWithEmailAndPassword(email: email, password: pass).then((val) async {
       snackBarWidget("Login Successful");
       QuerySnapshot querySnapshot = await dbInst.where('uid',isEqualTo: authInst.currentUser?.uid).get();
       DocumentSnapshot userDoc = querySnapshot.docs.first;
       await userDoc.reference.update({
         'deviceToken': deviceToken,
       });
        return true;
      });
      return true;
    }on FirebaseAuthException catch (e) {
      print(e.code);
      if(e.code=="invalid-credential") {
          snackBarWidget("User Not Found or Invalid Credentials");
        }
      return false;
    }
  }

  signout(context) async {
    await authInst.signOut().then((val){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>loginView()));
      snackBarWidget("Logout Successful");
    }).onError((e,s){
      snackBarWidget("Logout $s");
    });

  }
  Future<void> updateDeviceToken(String userId, String newDeviceToken) async {
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
    dbInst.where('uid',isEqualTo: authInst.currentUser?.uid).get();
    try {
      await usersCollection.doc(userId).update({
        'deviceToken': newDeviceToken,
      });
      print("Device token updated successfully.");
    } catch (e) {
      print("Failed to update device token: $e");
    }
  }

}