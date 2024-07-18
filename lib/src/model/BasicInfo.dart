import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
BasicInfo basicInfoObject=BasicInfo();

class BasicInfo {
  final String CompanyName;
  final String Industury;
  final Timestamp? FoundedDate;
  late final List<dynamic>? Founders;
  final String Location;

  final CollectionReference ref = FirebaseFirestore.instance.collection("Info");
  BasicInfo({
    this.CompanyName="Tech Roble",
    this.Industury="Indus",
    this.FoundedDate,
    this.Founders,
    this.Location="Johor Town",
  });


  static fromDocument(DocumentSnapshot doc)  {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
     return BasicInfo(
       CompanyName: data['Company Name'],
       Industury: data['Industry'],
       FoundedDate: data['FoundedDate'],
       Founders: data['Founders'],
       Location: data['Location'],
     );
  }

  Future<void> addInfo(String Cname,String indus,String loc,Timestamp date,List<dynamic> found,String id)async {
    ref.add({
      'Company Name':Cname,
      'Industry':indus,
      'Location':loc,
      'FoundedDate':date,
      'Founders':found,
      'uid':id
    });
  }

  Future<void> UpdateInfo(String DocId, String Cname,String indus,String loc,Timestamp date,List<dynamic> found)async {
    ref.doc(DocId).update({
      'Company Name':Cname,
      'Industry':indus,
      'Location':loc,
      'FoundedDate':date,
      'Founders':found
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

  Future<void> deleteFounder(String founderId, String founderName,BuildContext context) async {
    try {
      await ref.doc(founderId).update({'Founders': FieldValue.arrayRemove([founderName])
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$founderName deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete $founderName: $e'),
        ),
      );
    }
  }

}
