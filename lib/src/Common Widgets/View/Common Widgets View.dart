import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

buttonWidget(String Title,Function()? onTap){
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xff007665),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              Title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}


textFormFieldWidget(TextEditingController? controller,String? hintText,String label,{bool obscureText = false}){
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '*',
      decoration: InputDecoration(
          hintText:hintText,
          label: Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.greenAccent))),
    ),
  );
}

alignTextWithColor(AlignmentGeometry alignment, String textWithoutColor,String textWithColor,Function()? onTap){
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Align(
      alignment: alignment,
      child: RichText(
        text: TextSpan(
            text: textWithoutColor,
            style: TextStyle(fontSize: 15, color: Colors.black),
            children: [
              TextSpan(
                  text: textWithColor,
                  style: TextStyle(color: Colors.green),
                  recognizer: TapGestureRecognizer()
                    ..onTap=onTap
              ),
            ]),
      ),
    ),
  );
}

appBarWidget(String text){
  return AppBar(
    title: Center(
      child: Text(text),

    ),
  );
}

snackBarWidget(String message){
  return Get.snackbar("Alert",message,
  backgroundColor: Color(0xff279484),
    colorText: Colors.white


  );
}