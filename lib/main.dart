import 'package:flutter/material.dart';
import 'package:productcatalogue/src/home/view/homeScreenView.dart';
import 'package:productcatalogue/src/home/viewModel/homeViewModel.dart';
import 'package:productcatalogue/src/login/view/loginView.dart';
import 'package:productcatalogue/src/login/viewModel/loginViewModel.dart';

import 'package:productcatalogue/src/splashScreen/view/splashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>loginViewModel()),
        ChangeNotifierProvider(create: (context)=>homeViewModel()),
      ],
      child: MyApp(),
    ),
  );
}
// add comment for branch
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/loginView': (context) => loginView(),
          '/homeScreenView': (context) => homeScreenView(),
        },
      home: splashScreenView()
    );
  }
}