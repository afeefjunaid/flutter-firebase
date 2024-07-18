import 'dart:async';
import 'dart:typed_data';
import 'package:adminpanel/src/common_Widgets/Common_Widget.dart';
import 'package:adminpanel/src/common_Widgets/color.dart';
import 'package:adminpanel/src/common_Widgets/imageUpload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/Clients.dart';
import '../model/authentication.dart';

final firestoreInstance = FirebaseFirestore.instance.collection("Clients");

class adminClientPage extends StatefulWidget {
  @override
  State<adminClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<adminClientPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late final FocusNode nameFocus;
  late final FocusNode emailFocus;
  late final FocusNode passwordFocus;

  late Clients client = Clients();
  bool toggleClient=false;

  var clientKey = GlobalKey<FormState>();

  final String defaultImageUrl =
      'https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg';

  @override
  void initState() {
    nameFocus = FocusNode();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    selectedImage = Uint8List(0);
    super.initState();
    _initializeDefaultImage();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  late Uint8List selectedImage;

  Future<void> _initializeDefaultImage() async {
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

  Future<void> selectImage() async {
    Uint8List img = Uint8List(0);
    Completer<Uint8List> completer = Completer<Uint8List>();
    await showBottomSheetWidget(context, completer);
    img = await completer.future;
    selectedImage = img;
    setState(() {});
  }

  void resetFields() async {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    setState(() {});
  }

  Future<void> showDialogBox(BuildContext context, String? id,
      {Clients? client}) async {
    if (id != null) {
      DocumentSnapshot docSnapshot = await firestoreInstance.doc(id).get();
      if (docSnapshot.exists) {
        client = Clients.fromDocument(docSnapshot);
        nameController.text = client.name;
        emailController.text = client.email;
        passwordController.text = client.password;
        selectedImage = await _loadNetworkImage(client.imageURL);
      }
    } else {
      client = Clients();
      resetFields();
      selectedImage = await _loadNetworkImage(defaultImageUrl);
    }

    showDialog(
      context: context,
      builder: (cont) {
        return AlertDialog(
          title: Text(client!.name.isEmpty ? "New Client" : "Edit Client"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Form(
                key: clientKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      stackWidget(
                        MemoryImage(selectedImage),
                        () async {
                          await selectImage();
                          setDialogState(() {});
                        },
                        Icons.photo_camera,
                      ),
                      textFormFieldWiget(
                        "Enter Your Name",
                        nameController,
                        nameFocus,
                        Icon(Icons.person),
                        () {
                          setDialogState(() {
                            nameFocus.requestFocus();
                          });
                        },
                        "Name",
                        null,
                        TextInputType.text,
                        false,
                        (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Valid Name";
                          } else {
                            return null;
                          }
                        },
                        (val) {
                          setState(() {});
                        },
                      ),
                      textFormFieldWiget(
                        "Enter Your Email",
                        emailController,
                        emailFocus,
                        Icon(Icons.email),
                        () {
                          setDialogState(() {
                            emailFocus.requestFocus();
                          });
                        },
                        "Email",
                        null,
                        TextInputType.emailAddress,
                        false,
                        (val) {
                          if (val!.isEmpty ||
                              !val.contains("@") ||
                              !val.contains("gmail.com")) {
                            return "Please Enter Valid Email";
                          } else {
                            return null;
                          }
                        },
                        (val) {
                          setState(() {});
                        },
                      ),
                      textFormFieldWiget(
                        "Enter Your Password",
                        passwordController,
                        passwordFocus,
                        Icon(Icons.password),
                        () {
                          setDialogState(() {
                            passwordFocus.requestFocus();
                          });
                        },
                        "Password",
                        null,
                        TextInputType.text,
                        true,
                        (val) {
                          if (val!.isEmpty || val.length < 6) {
                            return "Please Enter Valid Password";
                          } else {
                            return null;
                          }
                        },
                        (val) {
                          setState(() {});
                        },
                      ),
                      elevatedButtonWidget(
                        () async {
                          if (clientKey.currentState!.validate()) {
                            if (id == null) {
                              Authentication.createUser(emailController.text,
                                      passwordController.text)
                                  .then((val) async {
                                await client
                                    ?.saveData(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text,
                                  selectedImage,
                                  val!.uid,
                                )
                                    .then((val) {
                                  resetFields();
                                });
                              });
                            } else {
                              await client?.updateData(
                                emailController.text,
                                selectedImage,
                                id,
                              );
                            }
                            Navigator.pop(context);
                          }
                        },
                        client!.name.isEmpty ? "Save" : "Update",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Clients"),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreInstance.snapshots(),
          builder: (context, snapshots) {
    if (snapshots.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());}
            else if (snapshots.hasData) {
              List<DocumentSnapshot> clientlist = snapshots.data?.docs ?? [];
              return ListView.builder(
                  itemCount: clientlist.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = clientlist[index];
                    String docid = doc.id;
                    client = Clients.fromDocument(doc);
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              margin: EdgeInsets.all(6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: client.isClientDisabled
                                      ? Colors.red
                                      : color
                                          .ColorGenrator(), // Use the color generator or red based on the condition, // color of the border
                                  width: 2, // width of the border
                                ),
                              ),
                              elevation: 5,
                              child: ListTile(
                                title: Text(
                                  client.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                subtitle: Text(client.email,
                                    style: TextStyle(fontSize: 15)),
                                trailing: client.isClientDisabled == false
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showDialogBox(context, docid);
                                            },
                                            icon: Icon(Icons.settings),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              DocumentSnapshot docSnapshot =
                                                  await firestoreInstance
                                                      .doc(docid)
                                                      .get();
                                              if (docSnapshot.exists) {
                                                client = Clients.fromDocument(
                                                    docSnapshot);
                                              }
                                              toggleClient=true;
                                              client.toggleClient(toggleClient,docid);
                                            },

                                            icon: Icon(Icons.disabled_by_default),
                                          ),
                                        ],
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          DocumentSnapshot docSnapshot = await firestoreInstance.doc(docid).get();
                                          if (docSnapshot.exists) {
                                            client = Clients.fromDocument(docSnapshot);
                                          }
                                          toggleClient=false;
                                          client.toggleClient(toggleClient,docid);
                                        },
                                        icon: Icon(Icons.check_circle),
                                      ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(client.imageURL),
                                  radius: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshots.hasError) {
              return Text("Error Occurred");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: floatingActionButtonWidget(() async {
        showDialogBox(context, null);

      }, Icons.add),


    );
  }
}
