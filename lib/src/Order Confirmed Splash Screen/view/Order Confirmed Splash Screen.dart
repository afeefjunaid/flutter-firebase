import 'dart:async';

import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';

class orderConfirmedSplashScreen extends StatefulWidget {
  const orderConfirmedSplashScreen({super.key});

  @override
  State<orderConfirmedSplashScreen> createState() => _orderConfirmedSplashScreenState();
}

class _orderConfirmedSplashScreenState extends State<orderConfirmedSplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 3),(){
      Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>homeScreenView()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: Center(
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
          "Thank You For Your Payment.\nYour Order Is Confirmed",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),);
  }
}
