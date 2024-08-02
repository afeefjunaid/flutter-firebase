import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productcatalogue/src/forgotPassword/view/forgotPasswordView.dart';
import 'package:productcatalogue/src/home/view/homeScreenView.dart';
import 'package:productcatalogue/src/landingScreen/view/landingScreenView.dart';
import 'package:productcatalogue/src/signup/view/signupView.dart';
import '../../Scaffold/viewModel/scaffoldViewModel.dart';
import '../../commonWidgets/commonWidgets.dart';
import '../../API/apiClient.dart';

class loginView extends StatefulWidget {
  @override
  State<loginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<loginView> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var loginkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return BaseScaffold(
      body: listViewWithPadding(
          [
            headingText("Login"),
            spacingInHeight(context, 0.01),
            Form(
              key: loginkey,
             child:Column(
               children: [
               buildTextFormField(
               "Enter Your Username",
                 userNameController,
               validator: (val) {
                 if (val!.isEmpty) {
                   return "Please Enter a Valid Username";
                 } else {
                   return null;
                 }
               },
             ),
              spacingInHeight(context, 0.01),
              buildTextFormField("Enter Your Password", passwordController,
                  obscureText: true, validator: (val) {
                    if(val!.length<6){
                      return "Please Enter Atleast 6 Characters";
                    }
                    else{
                      return null;
                    }
                  }),
              spacingInHeight(context, 0.01),
               ],
             ),
            ),
            alignTextToLeft("", "Forgot Password", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => forgotPasswordView()));
            }),
            spacingInHeight(context, 0.01),
            buildButton("LOGIN", () {
              if (loginkey.currentState != null &&
                  loginkey.currentState!.validate()) {
                loginkey.currentState!.save();
                ApiClient.postRequest(userNameController.text,passwordController.text,context,'auth/login');
              }
            }),
            spacingInHeight(context, 0.01),
            alignTextToLeft("If You Dont Have an Account Please ", "Signup",
                () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => signupView()));
            }),
            buildButton("Go to home page",(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>landingScreen()));
            }),
            spacingInHeight(context, 0.25),
            Center(
                child: Text(
              "Or login with social account",
              style: TextStyle(fontSize: 16),
            )),
            spacingInHeight(context, 0.01),
            buildSocialMediaRow(),
          ],
        ),
    );
  }
}
