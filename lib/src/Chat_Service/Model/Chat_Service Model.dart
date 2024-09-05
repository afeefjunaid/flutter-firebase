import 'package:cloud_firestore/cloud_firestore.dart';

class chat_ServiceModel{
  final String senderID;
  final String? senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  chat_ServiceModel({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp
  });


  Map<String, dynamic>toMap(){
    return{
      'senderId':senderID,
      'senderEmail':senderEmail,
      "receiverId":receiverID,
      "message":message,
      'timestamp':timestamp
    };
  }
}