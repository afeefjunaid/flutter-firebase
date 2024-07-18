import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:adminpanel/src/common_Widgets/Common_Widget.dart';
import 'package:adminpanel/src/common_Widgets/color.dart';
import 'package:adminpanel/src/views/businessDetailsPage.dart';
import 'package:adminpanel/src/views/adminClientsPage.dart';
import 'package:adminpanel/src/views/keyPersonalPage.dart';
import 'package:adminpanel/src/views/loginPage.dart';
import 'package:adminpanel/src/views/contactInfoPage.dart';
import 'package:adminpanel/src/model/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../common_Widgets/imageUpload.dart';
import '../model/BasicInfo.dart';
import '../model/ContactInfo.dart';
import 'basicInfoPage.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> with SingleTickerProviderStateMixin {
  bool startAnimation = false;
  Uint8List? selectedImage;
  final String defaultImageUrl =
      'https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg';

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
    _initializeDrawerImage();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeDrawerImage() async {
    try {
      String imageName = "Comp Image";
      String imageUrl = await _getFirebaseImageUrl(imageName);
      selectedImage = await _loadNetworkImage(imageUrl);
    } catch (e) {
      print('Error loading Firebase image: $e');
      selectedImage = await _loadNetworkImage(defaultImageUrl);
    }
    // setState(() {});
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
    String imageUrl = await uploadImage.uploadImageToFirebase("Comp Image", selectedImage!);
  }

  Future<String> _getFirebaseImageUrl(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(imageName);
    final url = await ref.getDownloadURL();
    return url;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDrawerStateChange(bool isOpened) {
    if (isOpened) {
      _animationController.reset();
      _animationController.forward();
    }
    _initializeDrawerImage();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget(basicInfoObject.CompanyName??''),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(color: color.ColorGenrator()),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setDialogState) {
                  return Column(
                    children: [
                      stackWidget(
                        selectedImage == null
                            ? NetworkImage(defaultImageUrl)
                            : MemoryImage(selectedImage!),
                            () => selectImage(),
                        Icons.photo_camera,
                      ),
                      Text(basicInfoObject.CompanyName??''),
                      Text(contactinfoObject.Email),
                    ],
                  );
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  buildAnimatedTile(context, Icons.info, "Basic Information", basicInfoPage()),
                  buildAnimatedTile(context, Icons.contact_phone, "Contact Information", contactInfoPage()),
                  buildAnimatedTile(context, Icons.business, "Business Details", businessDetailsPage()),
                  buildAnimatedTile(context, Icons.person, "Key Personal", keyPersonal()),
                  buildAnimatedTile(context, Icons.people, "Clients", adminClientPage()),
                ],
              ),
            ),
          ],
        ),
      ),
      onDrawerChanged: _onDrawerStateChange,
      drawerEnableOpenDragGesture: true,
      body: Center(
        child: elevatedButtonWidget(() {
          Authentication.logout();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => loginPage()));
        }, "Logout"),
      ),
    );
  }

  Widget buildAnimatedTile(BuildContext context, IconData icon, String title, Widget page) {
    return SlideTransition(
      position: _offsetAnimation,
      child: inkWellWidget(() {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        setState(() {});
      }, title, icon),
    );
  }
}
