import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
 Contactinfo contactinfoObject=Contactinfo();
class Contactinfo {
  
  final contactInforef=FirebaseFirestore.instance.collection("ContactInfo");

  
  String? Address;
  int? PhoneNo;
  String Email;
  String? WebsiteURL;

  Contactinfo({
    this.Address,
    this.PhoneNo,
    this.Email="NoEmail.com",
    this.WebsiteURL
  });

  static Contactinfo fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Contactinfo(
      Address: data["Address"],
      PhoneNo: data["Phone Number"],
      Email: data["email"],
      WebsiteURL: data["website"]
    );
  }

  Future<void>addContactInfo(String Address,int no,String email,String website,String id)async {
    contactInforef.add({
      "Address":Address,
      "Phone Number":no,
      "email":email,
      "website":website,
      'uid':id
    });
  }
  Future<bool> checkIfDocumentWithFieldExists(
      String collectionPath, String field, dynamic value) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .where(field, isEqualTo: value)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking document existence: $e");
      return false;
    }
  }
  Future<void>UpdateContactInfo(String docid,String Address,int no,String email,String website)async {
    contactInforef.doc(docid).update({
      "Address":Address,
      "Phone Number":no,
      "email":email,
      "website":website,
    });
  }

}
