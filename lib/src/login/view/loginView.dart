import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productcatalogue/src/forgotPassword/view/forgotPasswordView.dart';
import 'package:productcatalogue/src/signup/view/signupView.dart';
import '../../commonWidgets/commonWidgets.dart';
import '../../home/view/homeScreenView.dart';

class loginView extends StatefulWidget {
  @override
  State<loginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<loginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: gradientBackground([Colors.red.shade100, Colors.white, Colors.white,]),
        child: listViewWithPadding(
           [
            headingText("Login"),
            spacingInHeight(context,0.01),
            buildTextFormField("Enter Your Email"),
            spacingInHeight(context,0.01),
            buildTextFormField("Enter Your Password"),
            spacingInHeight(context,0.01),
            alignTextToLeft("","Forgot Password",(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>forgotPasswordView()));
            }),
            spacingInHeight(context,0.01),
            buildButton("LOGIN",(){}),
            spacingInHeight(context,0.01),
            alignTextToLeft("If You Dont Have an Account Please ","Signup",(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>signupView()));
            } ),
            buildButton("Go to home page",(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homeScreenView()));
            }),
            spacingInHeight(context,0.25),
            Center(child: Text("Or login with social account",
              style: TextStyle(fontSize: 16),)),
            spacingInHeight(context,0.01),
            buildSocialMediaRow(),
          ],
        ),
      ),
    );
  }
}






