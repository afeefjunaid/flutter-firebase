import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:adminpanel/src/common_Widgets/color.dart';
import 'package:image_picker/image_picker.dart';

import 'imageUpload.dart';

textFormFieldWiget(
    String hint,
    TextEditingController? control,
    FocusNode? focus,
    Icon ic,
    VoidCallback? Pressed,
    String? text,
    void Function()? Tap,
    TextInputType? keyboardType,
    bool
        visible, // Make en parameter optional by placing it inside curly braces
    String? Function(String?)? validate,
    void Function(String?)? save,
    {bool? en}) {
  bool isEnabled = en ?? true; // If en is null, default to true
  return Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 15),
    child: TextFormField(
      controller: control,
      obscureText: visible,
      onTap: Tap,
      enabled: isEnabled, // Use the computed value of isEnabled
      focusNode: focus,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: ic,
          onPressed: Pressed,
          color: color.ColorGenrator(),
        ),
        labelText: text,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color.ColorGenrator()),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color.ColorGenrator()),
        ),
      ),
      validator: validate,
      onSaved: save,
    ),
  );
}

appBarWidget(String val) {

  return AppBar(
    title: Text(val),
    centerTitle: true,
    backgroundColor: color.ColorGenrator(),

  );
}

elevatedButtonWidget(Function()? onPressed, String val) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color.ColorGenrator()),
      onPressed: onPressed,
      child: Text(
        val,
        style: TextStyle(color: Colors.black),
      ));
}

inkWellWidget(void Function()? onTap, String Title, IconData iconData) {
  return InkWell(
    onTap: onTap,
    child: ListTile(
      title: Text(Title),
      leading: Icon(iconData, color: color.ColorGenrator()),
    ),
  );
}

floatingActionButtonWidget(void Function()? onPressed, IconData ic) {
  return FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: color.ColorGenrator(),
    child: Icon(ic),
  );
}

stackWidget(ImageProvider imageProvider, void Function()? onPressed, IconData ic) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(70),
        child: Image(
          height: 110,
          width: 110,
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(ic),
        ),
        bottom: -10,
        left: 70,
      )
    ],
  );
}

showBottomSheetWidget(BuildContext context, Completer<Uint8List> completer) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext con) {
      return Container(
        height: MediaQuery.of(con).size.height * .15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () async {
                    final img = await pickImage(ImageSource.gallery);
                    completer.complete(img);
                    Navigator.pop(con);
                  },
                  color: color.ColorGenrator(),
                  icon: Icon(Icons.browse_gallery),
                ),
                Text("Upload From Gallery"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () async {
                    final img = await pickImage(ImageSource.camera);
                    completer.complete(img);
                    Navigator.pop(con);
                  },
                  color: color.ColorGenrator(),
                  icon: Icon(Icons.camera),
                ),
                Text("Upload From Camera"),
              ],
            ),
          ],
        ),
      );
    },
  );
}
