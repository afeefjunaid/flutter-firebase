import 'package:chatapp/src/Notifications/View%20Model/Notifications%20View%20Model.dart';
import 'package:chatapp/src/Single%20Chats/View/Single%20Chats%20View.dart';
import 'package:chatapp/src/Splash%20Screen/View/Splash%20Screen%20View.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
final navigatorKey =GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  await initLocalNotifications();
  setupFirebaseMessaging();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: splashScreenView(),
        routes: {
        '/chat':(context)=>chatView(),
    },
    );
  }
}