import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Base Scaffold/View/Base Scaffold View.dart';
import '../../Chat_Service/view Model/Chat_Service View Model.dart';
import '../../Common Widgets/View/Common Widgets View.dart';
import '../../Notifications/View Model/Notifications View Model.dart';

class selectedChatView extends StatefulWidget {
  final selectedUser;
  selectedChatView({required this.selectedUser, super.key});

  @override
  State<selectedChatView> createState() => _selectedChatViewState();
}

class _selectedChatViewState extends State<selectedChatView> {

  TextEditingController messageController = TextEditingController();
  FirebaseAuth firebaseAuthinst = FirebaseAuth.instance;
  late ScrollController scrollController;
  chatServiceViewModel chatService = chatServiceViewModel();
  late FirebaseMessaging messaging;

  late String recordedFilePath;

  @override
  void initState() {
    super.initState();
    requestMicrophonePermission();
    scrollController = ScrollController();
    initializeFirebaseMessaging();


  }





  @override
  void dispose() {
    scrollController.dispose();
    messageController.dispose();

    super.dispose();
  }

  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }


  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      var m = messageController.text;
      messageController.clear();
      await sendNotificationToSelectedDevice(
        widget.selectedUser["deviceToken"],
        m,
        widget.selectedUser["name"],
      );
      await chatService.sendMessage(widget.selectedUser['uid'], m);

      scrollToBottom();
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    }
  }




  void initializeFirebaseMessaging() {
    messaging = FirebaseMessaging.instance;

    // Request notification permissions (required for iOS)
    messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen for messages while app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');

      }
    });

    // Handle background and terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });

    // Check if the app was opened from a terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('Received a message when the app was in terminated state!');
        print('Message data: ${message.data}');
      }
    });
  }





  buildMessageList() {
    return StreamBuilder(
        stream: chatService.getMessages(widget.selectedUser['uid'], firebaseAuthinst.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollToBottom();
            });
          }

          return ListView.builder(
            controller: scrollController,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (cnt, index) {
              var align = (snapshot.data!.docs[index]["senderId"] == firebaseAuthinst.currentUser?.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start;
              var bgclr = (snapshot.data!.docs[index]["senderId"] == firebaseAuthinst.currentUser?.uid)
                  ? Color(0xff007665)
                  : Colors.grey;

              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: align,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: bgclr,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 200,
                        ),
                        child: Wrap(
                          children: [
                            Text(
                              snapshot.data!.docs[index]["message"],
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
              CircleAvatar(
                child: Text(widget.selectedUser['name'][0].toUpperCase()),
              ),
              SizedBox(
                width: 15,
              ),
              Text(widget.selectedUser['name']),
              Spacer(),
              Icon(Icons.call),
              SizedBox(
                width: 15,
              ),
              Icon(Icons.video_camera_back_outlined),
            ],
          ),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: buildMessageList(),
        ),
        Row(children: [
          Expanded(
            child: textFormFieldWidget(
                messageController, "Enter Your Message", "Message"),
          ),
          Row(
            children: [
              GestureDetector(
                child: Icon(Icons.mic),
              ),
              IconButton(
                onPressed: () async {
                  sendMessage();
                },
                icon: Icon(Icons.send),
              ),
            ],
          )
        ])
      ]),
    );
  }
}
