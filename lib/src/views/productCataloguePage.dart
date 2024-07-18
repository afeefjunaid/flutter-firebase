import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../common_Widgets/Common_Widget.dart';
import '../common_Widgets/imageUpload.dart';
import '../model/productCatalogue.dart';

class productCataloguePage extends StatefulWidget {
  @override
  State<productCataloguePage> createState() => _ProductCatalogueState();
}

class _ProductCatalogueState extends State<productCataloguePage> {
  var formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late final FocusNode nameFocus;
  FocusNode priceFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  @override
  void dispose() {
    nameFocus.dispose();
    priceFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameFocus = FocusNode();
    priceFocus = FocusNode();
    descriptionFocus = FocusNode();
    _initializeDefaultImage();
    _initializeImage();
    super.initState();
  }

  final String defaultImageUrl =
      'https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg';

  _initializeDefaultImage() async {
    selectedImage = await _loadNetworkImage(defaultImageUrl);
    setState(() {});
  }

  Future<Uint8List> _loadNetworkImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load network image');
    }
  }

  Uint8List selectedImage = Uint8List(0);
  selectImage(StateSetter setDialogState) async {
    Uint8List img = Uint8List(0);
    Completer<Uint8List> completer = Completer<Uint8List>();
    await showBottomSheetWidget(context, completer);
    img = await completer.future;
    setDialogState(() {
      selectedImage = img;
    });
  }

  var inst = FirebaseFirestore.instance.collection("Product Catalogue");
  Future<void> _initializeImage() async {

    try {
      String imageUrl = await getFirebaseImageUrl(productCatalogueObject.name);
      selectedImage = await _loadNetworkImage(imageUrl);
    } catch (e) {
      print('Error loading Firebase image: $e');
      selectedImage = await _loadNetworkImage(defaultImageUrl);
    }
    setState(() {});
  }

  Future<String> getFirebaseImageUrl(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(imageName);
    final url = await ref.getDownloadURL();
    return url;
  }

  showDialogeBox(String id) async {
    if (id != null && id != "" && id.isNotEmpty) {
      DocumentSnapshot documentSnapshot = await inst.doc(id).get();
      if (documentSnapshot.exists) {
        productCatalogueObject =
            productCatalogue.fromDocument(documentSnapshot);
        nameController.text = productCatalogueObject.name;
        priceController.text = productCatalogueObject.price.toString();
        descriptionController.text = productCatalogueObject.description;
      }
    } else {
      nameController.text = "";
      priceController.text = "";
      descriptionController.text = "";
      selectedImage = await _loadNetworkImage(defaultImageUrl);
      setState(() {});
    }

    showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            title: Text("Add a Product"),
            content: StatefulBuilder(
              builder: (BuildContext con, StateSetter setDialogState) {
                return Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StatefulBuilder(builder:
                            (BuildContext con, StateSetter setDialogState) {
                          return Column(
                            children: [
                              stackWidget(
                                  selectedImage == null
                                      ? NetworkImage(defaultImageUrl)
                                      : MemoryImage(selectedImage), () async {
                                await selectImage(setDialogState);
                              }, Icons.photo_camera)
                            ],
                          );
                        }),
                        textFormFieldWiget(
                            "Enter Your Product Name",
                            nameController,
                            nameFocus,
                            Icon(Icons.drive_file_rename_outline),
                            () {
                              setState(() {
                                nameFocus.requestFocus();
                              });
                            },
                            "Name",
                            () {},
                            TextInputType.text,
                            false,
                            (val) {
                              if (val!.isEmpty) {
                                return "Please Enter a Valid Product Name";
                              } else {
                                return null;
                              }
                            },
                            (val) {}),
                        textFormFieldWiget(
                            "Enter Your Product Price",
                            priceController,
                            priceFocus,
                            Icon(Icons.currency_exchange_rounded),
                            () {
                              setState(() {
                                priceFocus.requestFocus();
                              });
                            },
                            "Price",
                            () {},
                            TextInputType.number,
                            false,
                            (val) {
                              if (val!.isEmpty || int.parse(val) <= 0) {
                                return "Please Enter a Valid Product Price";
                              } else {
                                return null;
                              }
                            },
                            (val) {}),
                        textFormFieldWiget(
                            "Enter Your Product Description",
                            descriptionController,
                            descriptionFocus,
                            Icon(Icons.summarize),
                            () {
                              setState(() {
                                descriptionFocus.requestFocus();
                              });
                            },
                            "Description",
                            () {},
                            TextInputType.text,
                            false,
                            (val) {
                              if (val!.isEmpty) {
                                return "Please Enter a Valid Product Description";
                              } else {
                                return null;
                              }
                            },
                            (val) {}),
                        elevatedButtonWidget(() async {
                          if (formkey.currentState!.validate()) {
                            formkey.currentState?.save();
                            productCatalogueObject.addProduct(
                                nameController.text,
                                double.parse(priceController.text),
                                descriptionController.text,
                                FirebaseAuth.instance.currentUser!.uid);
                            Navigator.pop(con);
                          }
                          await uploadImage.uploadImageToFirebase(
                              nameController.text, selectedImage);
                        }, "Save")
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    del();
    return Scaffold(
        appBar: appBarWidget("Product Catalogue"),
        body: GridView.count(
          crossAxisCount: 2,
          children: [],
        ),
        floatingActionButton: floatingActionButtonWidget(() {
          showDialogeBox("");
        }, Icons.add));
  }
  del() async{
   await FirebaseStorage.instance.ref().child('test@gmail.com').delete();
  }
}
