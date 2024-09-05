import 'package:chatapp/src/Landing%20Screen/View/Landing%20Screen%20View.dart';
import 'package:chatapp/src/Login/View/Login%20View.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class checkAuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return landingScreenView();
        } else {
          return loginView();
        }
      },
    );
  }
}