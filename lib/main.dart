import 'package:flutter/material.dart';
import 'package:productcatalogue/src/splashScreen/view/splashScreenView.dart';

void main() {
  runApp(const MyApp());
}
// add comment for branch
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splashScreenView()
    );
  }
}