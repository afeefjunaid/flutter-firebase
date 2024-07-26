import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../commonWidgets/commonWidgets.dart';

class splashScreenView extends StatefulWidget{
  @override
  State<splashScreenView>createState()=>_splashScreenView();
}

class _splashScreenView extends State<splashScreenView>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),(){
      Navigator.pushReplacementNamed(context, '/loginView');
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: gradientBackground([Colors.red.shade100, Colors.white, Colors.white,]),
        child: Center(
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.red.shade400,
                Colors.red,
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ).createShader(bounds),
            child: const Text(
              "Welcome To Product Catalogue App",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      );
  }
}