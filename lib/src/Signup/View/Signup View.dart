import 'package:chatapp/src/Authentication/View%20Model/Authentication%20View%20Model.dart';
import 'package:chatapp/src/Base%20Scaffold/View/Base%20Scaffold%20View.dart';
import 'package:chatapp/src/Common%20Widgets/View/Common%20Widgets%20View.dart';
import 'package:chatapp/src/Forgot%20Password/view/Forgot%20Password%20View.dart';
import 'package:chatapp/src/Landing%20Screen/View/Landing%20Screen%20View.dart';
import 'package:chatapp/src/Login/View/Login%20View.dart';
import 'package:flutter/material.dart';
import '../View Model/Signup View Model.dart';

class signupView extends StatefulWidget {
  const signupView({super.key});

  @override
  State<signupView> createState() => _signupViewState();
}

class _signupViewState extends State<signupView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      appBar: appBarWidget("Signup"),
      body: Padding(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              textFormFieldWidget(nameController, "Enter Your Name", "Name"),
              textFormFieldWidget(emailController, "Enter Your Email", "Email"),
              textFormFieldWidget(passwordController, "Enter Your Password", "Password",obscureText: true),
             alignTextWithColor(Alignment.centerRight, "Already Have An Account ", "Login", (){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>loginView()));
             }),
              alignTextWithColor(Alignment.centerRight, "Forgot ", "Password", (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>forgotPasswordView()));
              }),
              buttonWidget("Signup",() async {
                  if(await authenticationViewModel().signup(context, emailController.text, passwordController.text)) {
                signupViewModel().addUser(nameController.text,emailController.text,passwordController.text);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>landingScreenView()));
                }

              })
            ]),
      ),
    );
  }
}
