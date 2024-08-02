import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';
import 'package:productcatalogue/src/commonWidgets/commonWidgets.dart';
import 'package:productcatalogue/src/login/view/loginView.dart';

class forgotPasswordView extends StatefulWidget{
  @override
  State<forgotPasswordView>createState()=>_forgotPasswordView();
}

class _forgotPasswordView extends State<forgotPasswordView>{
  TextEditingController emailController=TextEditingController();

  @override
  Widget build(BuildContext context){
    return BaseScaffold(
      body:  listViewWithPadding([
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>loginView()));
            }, icon: Icon(Icons.keyboard_backspace)),
          ),
          headingText("Forgot Password"),
          spacingInHeight(context, 0.06),
          Text("Please enter your email address. You will receive a link to create a new password via email" ,style: TextStyle(fontSize: 16)),
          spacingInHeight(context, 0.03),
          buildTextFormField("Enter Your Email",emailController),
          spacingInHeight(context, 0.06),
          buildButton("Send",(){}),
        ]),
    );
  }
}