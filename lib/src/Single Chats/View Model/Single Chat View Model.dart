import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class singleChatViewModel{


  Future<List<QueryDocumentSnapshot<Object?>>> getOtherUsers() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where('uid', isNotEqualTo: currentUserId).get();
      return querySnapshot.docs;
    } on FirebaseException catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}