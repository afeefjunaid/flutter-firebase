import 'package:flutter/material.dart';
import 'package:productcatalogue/src/productDetail/view/productDetailView.dart';
import 'package:productcatalogue/src/shop/View/shopView.dart';
import '../../commonWidgets/commonWidgets.dart';

class homeScreenView extends StatefulWidget {
  @override
  State<homeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<homeScreenView> {
  int selectedIndex = 0;
  bool buttonState = true;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void toggleButton() {
    setState(() {
      buttonState = !buttonState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: gradientBackground([
          Colors.red.shade100,
          Colors.white,
          Colors.white,
        ]),
        child: ListView(
          children: [
            buildImageStack("asset/images/pic5.png", "Fashion\nsale", onPressed: () {}),
            SizedBox(height: 20),
            buildSectionTitle("Random"),
            buildHorizontalScrollView("asset/images/pic3.png","asset/images/pic8.png","Frok","Mexi","19.99\$","17.99\$",false, 3,3.5,buttonState: buttonState, toggleButton: toggleButton),
            SizedBox(height: 15),
            buildImageStack("asset/images/Small banner.png", "Clothes"),
            SizedBox(height: 20),
            buildSectionTitle("Sale"),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>productDetailView()));
                },
                child: buildHorizontalScrollView("asset/images/photo2.png", "asset/images/photo3.png","T Shirts","Casual Shirts","14.99\$","15.99\$",true, 3,3.5,buttonState: buttonState, toggleButton: toggleButton)),
            SizedBox(height: 20),
            buildSectionTitle("New"),
            buildHorizontalScrollView("asset/images/photo1.png","asset/images/pic8.png","Plain Shirts","Long Dress","29.99\$","22.99\$",false,4,5, buttonState: buttonState, toggleButton: toggleButton),
            SizedBox(height: 20),
            buildImageStack("asset/images/pic4.png", "New Collection"),
            buildTwoColumnImages(),
          ],
        ),
      ),
      bottomNavigationBar:bottomNavigationBarWidget(context,selectedIndex)
    );
  }
}
