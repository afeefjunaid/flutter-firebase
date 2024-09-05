import 'package:chatapp/src/Base%20Scaffold/View/Base%20Scaffold%20View.dart';
import 'package:flutter/material.dart';

import '../../Common Widgets/View/Common Widgets View.dart';

class forgotPasswordView extends StatefulWidget {
  const forgotPasswordView({super.key});

  @override
  State<forgotPasswordView> createState() => _forgotPasswordViewState();
}

class _forgotPasswordViewState extends State<forgotPasswordView> {
  TextEditingController emailController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      appBar: AppBar(
        title: Center(child: Text("Forgot Password"),),
      ),
      body: Column(
        children: [
          textFormFieldWidget(emailController,"Enter Your Email","Email"),
          Text("Forgot Password")
        ],
      ),
    );
  }
}
