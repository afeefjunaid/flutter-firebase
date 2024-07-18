import 'package:cloud_firestore/cloud_firestore.dart';
Keypersonal keypersonalObject=Keypersonal();
class Keypersonal{

  final keypersonalref=FirebaseFirestore.instance.collection("Key Personal");

  String? CEO;
  String? CFO;
  String? COO;
  String? CTO;

  Keypersonal({
    this.CEO,
    this.CFO,
    this.COO,
    this.CTO
  });

  static Keypersonal fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Keypersonal(
        CEO: data["CEO"],
        CFO: data["CFO"],
        COO: data["COO"],
        CTO: data["CTO"]
    );
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
  Future<void>addKeyPersonal(String ceo,String cfo,String coo,String cto,String id)async {
    keypersonalref.add({
      "CEO":ceo,
      "CFO":cfo,
      "COO":coo,
      "CTO":cto,
      'uid':id
    });
  }
  Future<void>updateKeyPersonal(String docid,String ceo,String cfo,String coo,String cto)async {
    keypersonalref.doc(docid).update({
      "CEO":ceo,
      "CFO":cfo,
      "COO":coo,
      "CTO":cto,
    });
  }

}