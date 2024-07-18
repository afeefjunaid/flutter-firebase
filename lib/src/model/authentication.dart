import 'dart:developer';

import 'package:adminpanel/src/common_Widgets/color.dart';
import 'package:adminpanel/src/model/Clients.dart';
import 'package:adminpanel/src/views/homePage.dart';
import 'package:adminpanel/src/views/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../views/clientPage.dart';

class Authentication {
  static Future<User?> createUser(String Email, String Pass) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email,
        password: Pass,
      );
      return userCredential.user;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static login(String email, String pass, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((val) async {
        if (val.user!.uid == 'MMLzS2Fb5OR0ud7Cx8fJ0MHiLD73') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: color.ColorGenrator(),
              content: Text("You Are Logged In As Admin")));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homePage()));
        } else {
          await FirebaseFirestore.instance
              .collection("Clients")
              .where('uid', isEqualTo: val.user!.uid)
              .get()
              .then((nval) {
            if (nval.docs.first['isDisabled']) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                      "Your Account IS Disabled. Please Contact Administrator")));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: color.ColorGenrator(),
                  content: Text("You Are Logged In As Client")));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => clientPage()));
            }
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    }
  }

  static logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static deleteClient(BuildContext con) async {
    QuerySnapshot InfoquerySnapshot = await FirebaseFirestore.instance.collection('Info').where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    var Infodocs=InfoquerySnapshot.docs;
    if(Infodocs.isNotEmpty) {
        var Infodocid=Infodocs.first.id;
        FirebaseFirestore.instance.collection('Info').doc(Infodocid).delete();
    }

    QuerySnapshot ContactInfoquerySnapshot = await FirebaseFirestore.instance
        .collection('ContactInfo').where(
        "uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    var Contactdocs = ContactInfoquerySnapshot.docs;
    if(Contactdocs.isNotEmpty) {
      var Contactdocid=Contactdocs.first.id;
      FirebaseFirestore.instance.collection('ContactInfo').doc(Contactdocid).delete();
    }

    QuerySnapshot KeyPersonalquerySnapshot = await FirebaseFirestore.instance.collection('Key Personal').where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    var KeyPersonaldocs=KeyPersonalquerySnapshot.docs;
    if(KeyPersonaldocs.isNotEmpty) {
      var KeyPersonaldocid=KeyPersonaldocs.first.id;
      FirebaseFirestore.instance.collection('Key Personal').doc(KeyPersonaldocid).delete();
    }


    QuerySnapshot BusinessDetailsquerySnapshot = await FirebaseFirestore.instance.collection('Business Details').where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    var BusinessDetaildocs=BusinessDetailsquerySnapshot.docs;
    if(BusinessDetaildocs.isNotEmpty) {
      var BusinessDetaildocid=BusinessDetaildocs.first.id;
      FirebaseFirestore.instance.collection('Business Details').doc(BusinessDetaildocid).delete();
    }

    QuerySnapshot ClientsquerySnapshot = await FirebaseFirestore.instance.collection('Clients').where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    var Clientsdocs = ClientsquerySnapshot.docs;
    if (Clientsdocs.isNotEmpty) {


      Map<String, dynamic> i = Clientsdocs.first.data() as Map<String, dynamic>;
      User? user = FirebaseAuth.instance.currentUser;
      var credential = EmailAuthProvider.credential(
          email: i["email"],
          password: i["password"]);
      await user!.reauthenticateWithCredential(credential);
      await user!.delete().then((val) {
        var Clientsdocid=Clientsdocs.first.id;
        FirebaseFirestore.instance.collection('Clients').doc(Clientsdocid).delete();
        ScaffoldMessenger.of(con).showSnackBar(SnackBar(
            backgroundColor: color.ColorGenrator(),
            content: Text("Your Account Has Been Deleted Successfully")));
        Navigator.pushReplacement(con, MaterialPageRoute(builder: (context)=>loginPage()));
      });


    }
  }
}
