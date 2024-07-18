import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../common_Widgets/Common_Widget.dart';
import '../common_Widgets/imageUpload.dart';
import '../model/BasicInfo.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class basicInfoPage extends StatefulWidget {
  @override
  State<basicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<basicInfoPage> {
  Uint8List? selectedImage;
  final String defaultImageUrl =
      'https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg';

  final firestoreInstance = FirebaseFirestore.instance
      .collection("Info")
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  late FocusNode companyNameFocusNode;
  late FocusNode industryFocusNode;
  late FocusNode headquartersLocationFocusNode;
  late FocusNode FoundedDateFoucs;
  late FocusNode FounderFocus;
  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  late Timestamp FoundedDate;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController headquartersLocationController =
  TextEditingController();
  TextEditingController foundersController = TextEditingController();
  TextEditingController foundedDateController = TextEditingController();

  DateTime? selectedDate;

  bool controllersInitialized = false;
  List<dynamic> Dummy = [];

  Future<void> selectImage() async {
    Uint8List img = Uint8List(0);
    Completer<Uint8List> completer = Completer<Uint8List>();
    await showBottomSheetWidget(context, completer);
    img = await completer.future;
    selectedImage = img;
    setState(() {});
    await uploadImage.uploadImageToFirebase("Comp Image", selectedImage!);
  }

  Future<Uint8List> _loadNetworkImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load network image');
    }
  }

  Future<void> _initializeDrawerImage() async {
    try {
      String imageUrl = await _getFirebaseImageUrl("Comp Image");
      selectedImage = await _loadNetworkImage(imageUrl);
    } catch (e) {
      print('Error loading Firebase image: $e');
      selectedImage = await _loadNetworkImage(defaultImageUrl);
    }
    setState(() {});
  }

  Future<String> _getFirebaseImageUrl(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(imageName);
    final url = await ref.getDownloadURL();
    return url;
  }

  @override
  void initState() {
    super.initState();
    companyNameFocusNode = FocusNode();
    industryFocusNode = FocusNode();
    headquartersLocationFocusNode = FocusNode();
    FoundedDateFoucs = FocusNode();
    FounderFocus = FocusNode();
    _initializeDrawerImage();
    _checkAndGetFounders();
  }
  Future<void> _checkAndGetFounders() async {
    bool documentExists = await basicInfoObject.checkIfDocumentWithFieldExists(
        'Info', 'uid', FirebaseAuth.instance.currentUser!.uid);
    if (documentExists) {
      getfounders();
    }
  }
  @override
  void dispose() {
    companyNameFocusNode.dispose();
    industryFocusNode.dispose();
    headquartersLocationFocusNode.dispose();
    FoundedDateFoucs.dispose();
    FounderFocus.dispose();
    super.dispose();
  }

  getfounders() {
    firestoreInstance.get().then((val) {
      setState(() {
        Dummy = List.from(val.docs.first['Founders']);
      });
    });
  }

  void _selectDate(BuildContext context, BasicInfo basicInfo) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: basicInfo.FoundedDate?.toDate() ?? DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        foundedDateController.text = DateFormat('yMMMd').format(selectedDate!);
        FoundedDate = Timestamp.fromDate(selectedDate!);
      });
    }
  }

  void initializeControllers(BasicInfo basic) {
    if (!controllersInitialized) {
      companyNameController.text = basic.CompanyName!;
      industryController.text = basic.Industury!;
      headquartersLocationController.text = basic.Location;
      if (basic.FoundedDate != null) {
        DateTime? date = basic.FoundedDate?.toDate();
        foundedDateController.text = DateFormat('yMMMd').format(date!);
        FoundedDate = basic.FoundedDate!;
      }
      controllersInitialized = true;
    }
  }



  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Basic Information"),
      body: FutureBuilder<bool>(
        future: basicInfoObject.checkIfDocumentWithFieldExists(
            'Info', 'uid', FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!) {
            return StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance.snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  List<DocumentSnapshot> infolist =
                  snapshots.data == null ? [] : snapshots.data!.docs;
                  return infolist == null
                      ? Text("No Data Found")
                      : ListView.builder(
                    itemCount: infolist.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = infolist[index];
                      String docid = doc.id;
                      basicInfoObject = BasicInfo.fromDocument(doc);
                      initializeControllers(basicInfoObject);
                      return Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formkey,
                            child: Column(
                              children: [
                                StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setDialogState) {
                                    return Column(
                                      children: [
                                        stackWidget(
                                          selectedImage == null
                                              ? NetworkImage(
                                              defaultImageUrl)
                                              : MemoryImage(
                                              selectedImage!),
                                              () => selectImage(),
                                          Icons.photo_camera,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                textFormFieldWiget(
                                    "Enter Your Company Name",
                                    companyNameController,
                                    companyNameFocusNode,
                                    Icon(Icons.business),
                                        () {
                                      setState(() {
                                        companyNameFocusNode.requestFocus();
                                      });
                                    },
                                    'Company Name',
                                    null,
                                    TextInputType.text,
                                    false, (val) {
                                  if (val!.isEmpty) {
                                    return "Please Enter Valid Company Name";
                                  } else {
                                    return null;
                                  }
                                }, (val) {
                                  setState(() {});
                                }),
                                textFormFieldWiget(
                                    "Enter Your Industury Name",
                                    industryController,
                                    industryFocusNode,
                                    Icon(Icons.work),
                                        () {
                                      setState(() {
                                        industryFocusNode.requestFocus();
                                      });
                                    },
                                    'Industry',
                                    null,
                                    TextInputType.text,
                                    false, (val) {
                                  if (val!.isEmpty) {
                                    return "Please Enter Valid Industry Name";
                                  } else {
                                    return null;
                                  }
                                }, (val) {
                                  setState(() {});
                                }),
                                textFormFieldWiget(
                                  "Select a Date",
                                  foundedDateController,
                                  FoundedDateFoucs,
                                  Icon(Icons.date_range_sharp),
                                      () {
                                    setState(() {
                                      _selectDate(
                                          context, basicInfoObject);
                                      FoundedDateFoucs.requestFocus();
                                    });
                                  },
                                  'Founded Date',
                                      () {
                                    _selectDate(context, basicInfoObject);
                                  },
                                  TextInputType.number,
                                  false, (val) {
                                  if (val!.isEmpty) {
                                    return "Please Enter Valid Date";
                                  } else {
                                    return null;
                                  }
                                }, (val) {
                                  setState(() {
                                    _selectDate(
                                        context, basicInfoObject);
                                  });
                                },
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Founders',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: SizedBox(
                                    child: ListView.builder(
                                        itemCount: Dummy.length,
                                        scrollDirection:
                                        Axis.horizontal,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                right: 10),
                                            child: Chip(
                                              deleteIconColor:
                                              Colors.grey,
                                              deleteIcon:
                                              Icon(Icons.cancel),
                                              onDeleted: () {
                                                Dummy.removeAt(i);
                                                setState(() {});
                                              },
                                              label: Text(Dummy[i]),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                Container(height: 20),
                                textFormFieldWiget(
                                    "Enter Founder Name",
                                    foundersController,
                                    FounderFocus,
                                    Icon(Icons.save),
                                        () {
                                      setState(() {
                                        FounderFocus.requestFocus();
                                        if (foundersController.text != "") {
                                          Dummy.add(
                                              foundersController.text);
                                          foundersController.text = "";
                                        }
                                      });
                                    },
                                    'Add Founder',
                                    null,
                                    TextInputType.text,
                                    false, (val) {
                                  if (Dummy.isEmpty) {
                                    return "Please Add Atleast One Founder";
                                  } else {
                                    return null;
                                  }
                                }, null),
                                textFormFieldWiget(
                                    "Enter Headquarter Location",
                                    headquartersLocationController,
                                    headquartersLocationFocusNode,
                                    Icon(Icons.location_on),
                                        () {
                                      setState(() {
                                        headquartersLocationFocusNode
                                            .requestFocus();
                                      });
                                    },
                                    'Headquarters Location',
                                    null,
                                    TextInputType.text,
                                    false, (val) {
                                  if (val == "") {
                                    return "Please Enter Valid Location";
                                  } else {
                                    return null;
                                  }
                                }, (val) {
                                  setState(() {});
                                }),
                                elevatedButtonWidget(() {
                                  if (!formkey.currentState!.validate()) {
                                    formkey.currentState!.save();
                                  } else {
                                    basicInfoObject.UpdateInfo(
                                        docid,
                                        companyNameController.text,
                                        industryController.text,
                                        headquartersLocationController
                                            .text,
                                        FoundedDate,
                                        Dummy);
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
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey1,
                  child: Column(
                    children: [
                      StatefulBuilder(
                        builder: (BuildContext context,
                            StateSetter setDialogState) {
                          return Column(
                            children: [
                              stackWidget(
                                selectedImage == null
                                    ? NetworkImage(
                                    defaultImageUrl)
                                    : MemoryImage(
                                    selectedImage!),
                                    () => selectImage(),
                                Icons.photo_camera,
                              ),
                            ],
                          );
                        },
                      ),
                      textFormFieldWiget(
                          "Enter Your Company Name",
                          companyNameController,
                          companyNameFocusNode,
                          Icon(Icons.business),
                              () {
                            setState(() {
                              companyNameFocusNode.requestFocus();
                            });
                          },
                          'Company Name',
                          null,
                          TextInputType.text,
                          false, (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Valid Company Name";
                        } else {
                          return null;
                        }
                      }, (val) {
                        setState(() {});
                      }),
                      textFormFieldWiget(
                          "Enter Your Industury Name",
                          industryController,
                          industryFocusNode,
                          Icon(Icons.work),
                              () {
                            setState(() {
                              industryFocusNode.requestFocus();
                            });
                          },
                          'Industry',
                          null,
                          TextInputType.text,
                          false, (val) {
                        if (val!.isEmpty||val=="") {
                          return "Please Enter Valid Industry Name";
                        } else {
                          return null;
                        }
                      }, (val) {
                      }),
                      textFormFieldWiget(
                        "Select a Date",
                        foundedDateController,
                        FoundedDateFoucs,
                        Icon(Icons.date_range_sharp),
                            () {
                          setState(() {
                            log("Save");
                            _selectDate(context, basicInfoObject);
                            FoundedDateFoucs.requestFocus();
                          });
                        },
                        'Founded Date',
                            () {
                          _selectDate(context, basicInfoObject);
                          log("Save");
                        },
                        TextInputType.number,
                        false, (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Valid Date";
                        } else {
                          return null;
                        }
                      }, (val) {

                      },
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'Founders',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child: SizedBox(
                          child: ListView.builder(
                              itemCount: Dummy.length,
                              scrollDirection:
                              Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: 10),
                                  child: Chip(
                                    deleteIconColor:
                                    Colors.grey,
                                    deleteIcon:
                                    Icon(Icons.cancel),
                                    onDeleted: () {
                                      Dummy.removeAt(i);
                                      setState(() {});
                                    },
                                    label: Text(Dummy[i]),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Container(height: 20),
                      textFormFieldWiget(
                          "Enter Founder Name",
                          foundersController,
                          FounderFocus,
                          Icon(Icons.save),
                              () {
                            setState(() {
                              FounderFocus.requestFocus();
                              if (foundersController.text != "") {
                                Dummy.add(
                                    foundersController.text);
                                foundersController.text = "";
                              }
                            });
                          },
                          'Add Founder',
                          null,
                          TextInputType.text,
                          false, (val) {
                        if (Dummy.isEmpty) {
                          return "Please Add Atleast One Founder";
                        } else {
                          return null;
                        }
                      }, null),
                      textFormFieldWiget(
                          "Enter Headquarter Location",
                          headquartersLocationController,
                          headquartersLocationFocusNode,
                          Icon(Icons.location_on),
                              () {
                            setState(() {
                              headquartersLocationFocusNode
                                  .requestFocus();
                            });
                          },
                          'Headquarters Location',
                          null,
                          TextInputType.text,
                          false, (val) {
                        if (val == "") {
                          return "Please Enter Valid Location";
                        } else {
                          return null;
                        }
                      }, (val) {

                      }),
                      elevatedButtonWidget(() {
                        if (formkey1.currentState!.validate()) {
                          formkey1.currentState?.save();
                          basicInfoObject.addInfo(
                              companyNameController.text,
                              industryController.text,
                              headquartersLocationController.text,
                              FoundedDate,
                              Dummy,
                              FirebaseAuth.instance.currentUser!.uid
                          );
                        }
                      }, "Saved"),
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
