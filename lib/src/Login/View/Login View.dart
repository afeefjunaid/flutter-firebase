import 'package:chatapp/src/Authentication/View%20Model/Authentication%20View%20Model.dart';
import 'package:chatapp/src/Base%20Scaffold/View/Base%20Scaffold%20View.dart';
import 'package:chatapp/src/Common%20Widgets/View/Common%20Widgets%20View.dart';
import 'package:chatapp/src/Landing%20Screen/View/Landing%20Screen%20View.dart';
import 'package:chatapp/src/Signup/View/Signup%20View.dart';
import 'package:flutter/material.dart';

class loginView extends StatefulWidget {
  const loginView({super.key});

  @override
  State<loginView> createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return baseScaffold(
       appBar:  appBarWidget("Login"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textFormFieldWidget(emailController, "Enter Your Email", "Email"),
            textFormFieldWidget(passwordController, "Enter Your Password", "Password",obscureText: true),
            alignTextWithColor(Alignment.centerRight, "Don't Have Account ", "Signup", (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>signupView()));
            }),
            buttonWidget("Login",() async {
             if(await authenticationViewModel().login(emailController.text,passwordController.text)){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>landingScreenView()));

             }
            }),
          ]
        ),
      ),
    );
  }
}
