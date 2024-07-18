import 'package:adminpanel/src/common_Widgets/Common_Widget.dart';
import 'package:adminpanel/src/model/ContactInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class contactInfoPage extends StatefulWidget {
  @override
  State<contactInfoPage> createState() => _contactInfoState();
}

class _contactInfoState extends State<contactInfoPage> {
  final firestoreInstance = FirebaseFirestore.instance
      .collection("ContactInfo")
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  TextEditingController addressController = TextEditingController();
  TextEditingController phonenumController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  final contactInfoKey = GlobalKey<FormState>();

  late FocusNode addressFocus;
  late FocusNode phonenumFocus;
  late FocusNode emailFocus;
  late FocusNode websiteFocus;

  @override
  void initState() {
    super.initState();
    addressFocus = FocusNode();
    phonenumFocus = FocusNode();
    emailFocus = FocusNode();
    websiteFocus = FocusNode();
  }

  @override
  void dispose() {
    addressFocus.dispose();
    phonenumFocus.dispose();
    emailFocus.dispose();
    websiteFocus.dispose();
    super.dispose();
  }

  initializeControllers(Contactinfo info) {
    addressController.text = info.Address ?? '';
    phonenumController.text = info.PhoneNo.toString();
    emailController.text = info.Email ?? '';
    websiteController.text = info.WebsiteURL ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Contact Information"),
      body: FutureBuilder<bool>(
        future: contactinfoObject.checkIfDocumentWithFieldExists(
          "ContactInfo",
          'uid',
          FirebaseAuth.instance.currentUser!.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!) {
            return StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance.snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshots.hasError) {
                  return Center(child: Text('Error: ${snapshots.error}'));
                } else {
                  List<DocumentSnapshot> contactinfolist =
                  snapshots.data == null ? [] : snapshots.data!.docs;
                  return contactinfolist.isEmpty
                      ? Center(child: Text('No Contact Info Found'))
                      : ListView.builder(
                    itemCount: contactinfolist.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = contactinfolist[index];
                      String docid = doc.id;
                      Contactinfo contactinfoObject =
                      Contactinfo.fromDocument(doc);
                      initializeControllers(contactinfoObject);
                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Form(
                            key: contactInfoKey,
                            child: Column(
                              children: [
                                textFormFieldWiget(
                                  "Enter Your Address",
                                  addressController,
                                  addressFocus,
                                  Icon(Icons.home),
                                      () {
                                    setState(() {
                                      addressFocus.requestFocus();
                                    });
                                  },
                                  "Address",
                                  null,
                                  TextInputType.text,
                                  false,
                                      (val) {
                                    if (val!.isEmpty) {
                                      return "Please Enter a Valid Address";
                                    } else {
                                      return null;
                                    }
                                  },
                                      (val) {},
                                ),
                                textFormFieldWiget(
                                  "Enter Your Phone Number",
                                  phonenumController,
                                  phonenumFocus,
                                  Icon(Icons.phone),
                                      () {
                                    setState(() {
                                      phonenumFocus.requestFocus();
                                    });
                                  },
                                  "Phone Number",
                                  null,
                                  TextInputType.phone,
                                  false,
                                      (val) {
                                    if (val!.isEmpty ||
                                        val.length < 10 ||
                                        val.length > 10) {
                                      return "Please Enter a Valid Phone Number";
                                    } else {
                                      return null;
                                    }
                                  },
                                      (val) {},
                                ),
                                textFormFieldWiget(
                                  "Enter Your Email",
                                  emailController,
                                  emailFocus,
                                  Icon(Icons.email),
                                      () {
                                    setState(() {
                                      emailFocus.requestFocus();
                                    });
                                  },
                                  "Email",
                                  null,
                                  TextInputType.emailAddress,
                                  false,
                                      (val) {
                                    if (val!.isEmpty ||
                                        !val.contains("@")) {
                                      return "Please Enter a valid Email";
                                    } else {
                                      return null;
                                    }
                                  },
                                      (val) {},
                                ),
                                textFormFieldWiget(
                                  "Enter Your Website URL",
                                  websiteController,
                                  websiteFocus,
                                  Icon(Icons.link),
                                      () {
                                    setState(() {
                                      websiteFocus.requestFocus();
                                    });
                                  },
                                  "Website URL",
                                  null,
                                  TextInputType.text,
                                  false,
                                      (val) {
                                    if (val!.isEmpty ||
                                        !val.contains(".com") ||
                                        !val.contains("www.")) {
                                      return "Please Enter a Valid Website URL";
                                    } else {
                                      return null;
                                    }
                                  },
                                      (val) {},
                                ),
                                elevatedButtonWidget(() {
                                  if (contactInfoKey.currentState!
                                      .validate()) {
                                    contactinfoObject.UpdateContactInfo(
                                      docid,
                                      addressController.text,
                                      int.parse(phonenumController.text),
                                      emailController.text,
                                      websiteController.text,
                                    );
                                  }
                                }, "Save"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
             return Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: contactInfoKey,
                  child: Column(
                    children: [
                      textFormFieldWiget(
                        "Enter Your Address",
                        addressController,
                        addressFocus,
                        Icon(Icons.home),
                            () {
                          setState(() {
                            addressFocus.requestFocus();
                          });
                        },
                        "Address",
                        null,
                        TextInputType.text,
                        false,
                            (val) {
                          if (val!.isEmpty) {
                            return "Please Enter a Valid Address";
                          } else {
                            return null;
                          }
                        },
                            (val) {},
                      ),
                      textFormFieldWiget(
                        "Enter Your Phone Number",
                        phonenumController,
                        phonenumFocus,
                        Icon(Icons.phone),
                            () {
                          setState(() {
                            phonenumFocus.requestFocus();
                          });
                        },
                        "Phone Number",
                        null,
                        TextInputType.phone,
                        false,
                            (val) {
                          if (val!.isEmpty ||
                              val.length < 10 ||
                              val.length > 10) {
                            return "Please Enter a Valid Phone Number";
                          } else {
                            return null;
                          }
                        },
                            (val) {},
                      ),
                      textFormFieldWiget(
                        "Enter Your Email",
                        emailController,
                        emailFocus,
                        Icon(Icons.email),
                            () {
                          setState(() {
                            emailFocus.requestFocus();
                          });
                        },
                        "Email",
                        null,
                        TextInputType.emailAddress,
                        false,
                            (val) {
                          if (val!.isEmpty ||
                              !val.contains("@")) {
                            return "Please Enter a valid Email";
                          } else {
                            return null;
                          }
                        },
                            (val) {},
                      ),
                      textFormFieldWiget(
                        "Enter Your Website URL",
                        websiteController,
                        websiteFocus,
                        Icon(Icons.link),
                            () {
                          setState(() {
                            websiteFocus.requestFocus();
                          });
                        },
                        "Website URL",
                        null,
                        TextInputType.text,
                        false,
                            (val) {
                          if (val!.isEmpty ||
                              !val.contains(".com") ||
                              !val.contains("www.")) {
                            return "Please Enter a Valid Website URL";
                          } else {
                            return null;
                          }
                        },
                            (val) {},
                      ),
                      elevatedButtonWidget(() {
                        if (contactInfoKey.currentState!
                            .validate()) {
                          contactinfoObject.addContactInfo(
                            addressController.text,
                            int.parse(phonenumController.text),
                            emailController.text,
                            websiteController.text,
                            FirebaseAuth.instance.currentUser!.uid
                          );
                        }
                      }, "Save"),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
