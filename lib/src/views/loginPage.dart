import 'package:adminpanel/src/common_Widgets/Common_Widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/authentication.dart';

class loginPage extends StatefulWidget {
  @override
  State<loginPage> createState() => _loginState();
}

class _loginState extends State<loginPage> {

  late FocusNode emailFocus;
  late FocusNode passFocus;

  @override
  void initState() {
    emailFocus=FocusNode();
    passFocus=FocusNode();
    super.initState();
  }

  final loginKey=GlobalKey<FormState>();
  String email='';
  String pass='';
  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget("Login"),
    body: Form(
      key: loginKey,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFormFieldWiget("Enter Your Email",emailController,
                    emailFocus, Icon(Icons.email), (){
                  setState(() {
                    emailFocus.requestFocus();
                  });
                    }, "Email", null,
              TextInputType.text, false, (value){
            if(value!.isEmpty || !value.contains("@")) {
              return "Please Enter Valid Email";
            }
            else{
              return null;
            }
                  }, (value){
            setState(() {
              email=value!;
            });
          }),
                Container(height: 20,),
                textFormFieldWiget("Enter Your Password",passController, passFocus,
                Icon(Icons.password), (){
                  setState(() {
                    passFocus.requestFocus();
                  });
                    }, "Password", null,
    TextInputType.text, true, (value){
                    if(value!.length<6) {
                      return "Please Enter a Paswword Min of 6 Characters";
                    }
                    else {
                      return null;
                    }}, (value){
                      setState(() {
                        pass=value!;
                      });
                    }),
                Container(height: 20,),
                elevatedButtonWidget((){
                  if(loginKey.currentState!.validate())
                  {
                    loginKey.currentState!.save();
                  }
                  print("loginKey.currentState!.validate() ${loginKey.currentState!.validate()}");
                  Authentication.login(emailController.text,passController.text,context);

                },"Login"),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
