import 'package:chatapp/src/Chat_Service/Model/Chat_Service%20Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class chatServiceViewModel extends GetxController{

  final FirebaseFirestore firestoreinst=FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuthinst=FirebaseAuth.instance;

  Future<void>sendMessage(String receiverId,String message)async {
    final String currentUserId=firebaseAuthinst.currentUser!.uid;
    final String? currentUserEmail=firebaseAuthinst.currentUser?.email;
    final Timestamp timestamp=Timestamp.now();

    chat_ServiceModel newMessage=chat_ServiceModel(
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        receiverID: receiverId,
        message: message,
        timestamp: timestamp
    );

    List ids=[currentUserId,receiverId];
    ids.sort();
    String chatRoomID=ids.join("_");

    await firestoreinst.collection('chat_room').doc(chatRoomID).collection("messages").add(newMessage.toMap());
  }

   Stream<QuerySnapshot> getMessages(String userID,String otherID)  {
    List ids=[userID,otherID];
    ids.sort();
    String chatRoomID=ids.join("_");
    return firestoreinst.collection('chat_room').doc(chatRoomID).collection("messages").orderBy('timestamp',descending: false).snapshots();
  }





}