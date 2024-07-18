import 'package:adminpanel/src/common_Widgets/Common_Widget.dart';
import 'package:adminpanel/src/model/KeyPersonal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class keyPersonal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _keyPersonalState();
}

class _keyPersonalState extends State<keyPersonal> {
  final keyPersonalInstance = FirebaseFirestore.instance
      .collection("Key Personal")
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  late FocusNode ceoFocus;
  late FocusNode cfoFocus;
  late FocusNode cooFocus;
  late FocusNode ctoFocus;

  TextEditingController ceoController = TextEditingController();
  TextEditingController cfoController = TextEditingController();
  TextEditingController cooController = TextEditingController();
  TextEditingController ctoController = TextEditingController();

  final keyPersonalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    ceoFocus.dispose();
    cfoFocus.dispose();
    cooFocus.dispose();
    ctoFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ceoFocus = FocusNode();
    cfoFocus = FocusNode();
    cooFocus = FocusNode();
    ctoFocus = FocusNode();
    super.initState();
  }

  initializeControllers(Keypersonal detail) {
    ceoController.text = detail.CEO ?? '';
    cfoController.text = detail.CFO ?? '';
    cooController.text = detail.COO ?? '';
    ctoController.text = detail.CTO ?? '';
  }

  Future<bool> checkIfDocumentExists(String field, dynamic value) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Key Personal")
          .where(field, isEqualTo: value)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking document existence: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Key Personal"),
      body: FutureBuilder<bool>(
        future: checkIfDocumentExists('uid', FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!) {
            // Document exists, show ListView.builder
            return StreamBuilder<QuerySnapshot>(
              stream: keyPersonalInstance.snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshots.hasData) {
                  List<DocumentSnapshot> keyPersonalList =
                  snapshots.data!.docs.isNotEmpty ? snapshots.data!.docs : [];
                  return keyPersonalList.isEmpty
                      ? Center(child: Text('No Key Personal Info Found'))
                      : ListView.builder(
                    itemCount: keyPersonalList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = keyPersonalList[index];
                      String docId = doc.id;
                      Keypersonal keyPersonal = Keypersonal.fromDocument(doc);
                      initializeControllers(keyPersonal);
                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Form(
                            key: keyPersonalKey,
                            child: Column(
                              children: [
                                textFormFieldWiget(
                                  "Enter CEO Name",
                                  ceoController,
                                  ceoFocus,
                                  Icon(Icons.person),
                                      () {
                                    setState(() {
                                      ceoFocus.requestFocus();
                                    });
                                  },
                                  "CEO",
                                  null,
                                  TextInputType.text,
                                  false,
                                      (val) {
                                    if (val!.isEmpty) {
                                      return "Please Enter Valid CEO Name";
                                    }
                                    return null;
                                  },
                                      (val) {},
                                ),
                                textFormFieldWiget(
                                  "Enter CFO Name",
                                  cfoController,
                                  cfoFocus,
                                  Icon(Icons.person_outline_sharp),
                                      () {
                                    setState(() {
                                      cfoFocus.requestFocus();
                                    });
                                  },
                                  "CFO",
                                  null,
                                  TextInputType.text,
                                  false,
                                      (val) {
                                    if (val!.isEmpty) {
                                      return "Please Enter Valid CFO Name";
                                    }
                                    return null;
                                  },
                                      (val) {},
                                ),
                                textFormFieldWiget(
                                  "Enter COO Name",
                                  cooController,
                                  cooFocus,
                                  Icon(Icons.person_outline),
                                      () {
                                    setState(() {
                                      cooFocus.requestFocus();
                                    });
                                  },
                                  "COO",
                                  null,
                                  TextInputType.text,
                                  false,
                                      (val) {
                                    if (val!.isEmpty) {
                                      return "Please Enter Valid COO Name";
                                    }
                                    return null;
                                  },
                                      (val) {},
                                ),
                                textFormFieldWiget(
                                  "Enter CTO Name",
                                  ctoController,
                                  ctoFocus,
                                  Icon(Icons.perm_identity),
                                      () {
                                    setState(() {
                                      ctoFocus.requestFocus();
                                    });
                                  },
                                  "CTO",
                                  null,
                                  TextInputType.text,
                                  false,
                                      (val) {
                                    if (val!.isEmpty) {
                                      return "Please Enter Valid CTO Name";
                                    }
                                    return null;
                                  },
                                      (val) {},
                                ),
                                elevatedButtonWidget(() {
                                  if (keyPersonalKey.currentState!.validate()) {
                                    keyPersonal.updateKeyPersonal(
                                      docId,
                                      ceoController.text,
                                      cfoController.text,
                                      cooController.text,
                                      ctoController.text,
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
                } else if (snapshots.hasError) {
                  return Center(child: Text('Error: ${snapshots.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: keyPersonalKey,
                  child: Column(
                    children: [
                      textFormFieldWiget(
                        "Enter CEO Name",
                        ceoController,
                        ceoFocus,
                        Icon(Icons.person),
                            () {
                          setState(() {
                            ceoFocus.requestFocus();
                          });
                        },
                        "CEO",
                        null,
                        TextInputType.text,
                        false,
                            (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Valid CEO Name";
                          }
                          return null;
                        },
                            (val) {},
                      ),
                      textFormFieldWiget(
                        "Enter CFO Name",
                        cfoController,
                        cfoFocus,
                        Icon(Icons.person_outline_sharp),
                            () {
                          setState(() {
                            cfoFocus.requestFocus();
                          });
                        },
                        "CFO",
                        null,
                        TextInputType.text,
                        false,
                            (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Valid CFO Name";
                          }
                          return null;
                        },
                            (val) {},
                      ),
                      textFormFieldWiget(
                        "Enter COO Name",
                        cooController,
                        cooFocus,
                        Icon(Icons.person_outline),
                            () {
                          setState(() {
                            cooFocus.requestFocus();
                          });
                        },
                        "COO",
                        null,
                        TextInputType.text,
                        false,
                            (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Valid COO Name";
                          }
                          return null;
                        },
                            (val) {},
                      ),
                      textFormFieldWiget(
                        "Enter CTO Name",
                        ctoController,
                        ctoFocus,
                        Icon(Icons.perm_identity),
                            () {
                          setState(() {
                            ctoFocus.requestFocus();
                          });
                        },
                        "CTO",
                        null,
                        TextInputType.text,
                        false,
                            (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Valid CTO Name";
                          }
                          return null;
                        },
                            (val) {},
                      ),
                      elevatedButtonWidget(() {
                        if (keyPersonalKey.currentState!.validate()) {
                          keypersonalObject.addKeyPersonal(
                            ceoController.text,
                            cfoController.text,
                            cooController.text,
                            ctoController.text,
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
