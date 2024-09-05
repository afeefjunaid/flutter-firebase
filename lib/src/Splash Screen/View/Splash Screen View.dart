import 'dart:async';
import 'package:flutter/material.dart';
import '../../Check Auth/View/Check Auth View.dart';

class splashScreenView extends StatefulWidget {
  const splashScreenView({super.key});

  @override
  State<splashScreenView> createState() => _splashScreenViewState();
}

class _splashScreenViewState extends State<splashScreenView> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => checkAuthView()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "ChattApp",
          style: TextStyle(fontSize: 40, color: Color(0xff279484)),
        ),
      ),
    );
  }
}
