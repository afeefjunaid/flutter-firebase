import 'package:flutter/material.dart';
import 'package:productcatalogue/src/commonWidgets/commonWidgets.dart';
import 'package:productcatalogue/src/login/view/loginView.dart';

class signupView extends StatefulWidget{
  @override
  State<signupView>createState()=>_signupView();
}

class _signupView extends State<signupView>{

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController nameController=TextEditingController();


  @override
  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomInset: true,
      body: Container(
        decoration: gradientBackground([Colors.red.shade100, Colors.white, Colors.white]),
        child:listViewWithPadding(
          [
            headingText("Signup"),
            spacingInHeight(context,0.01),
            buildTextFormField("Enter Your Name",nameController),
            spacingInHeight(context,0.01),
            buildTextFormField("Enter Your Email",emailController),
            spacingInHeight(context,0.01),
            buildTextFormField("Enter Your Password",passwordController),
            spacingInHeight(context,0.01),
            alignTextToLeft("Already Have an ", "Account", (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>loginView()));
            }),
            spacingInHeight(context,0.03),
            buildButton("SIGNUP",(){}),
            spacingInHeight(context,0.18),
            Center(child: Text("Or sign up with social account",
              style: TextStyle(fontSize: 16),)),
            spacingInHeight(context,0.02),
            buildSocialMediaRow(),
          ],
        ),
      )


    );
  }
}

