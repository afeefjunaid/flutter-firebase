import 'package:chatapp/src/Base%20Scaffold/View/Base%20Scaffold%20View.dart';
import 'package:flutter/material.dart';

class comingSoon extends StatefulWidget {
  const comingSoon({super.key});

  @override
  State<comingSoon> createState() => _comingSoonState();
}

class _comingSoonState extends State<comingSoon> {
  @override
  Widget build(BuildContext context) {
    return baseScaffold(
        appBar: AppBar(title: Center(child: Text("Coming Soon",style: TextStyle(color: Colors.green),)),),
        body: Center(child: Text("Coming Soon",style: TextStyle(fontSize: 30,color: Colors.green),),));
  }
}
