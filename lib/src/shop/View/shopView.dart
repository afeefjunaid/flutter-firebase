import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';

import '../../commonWidgets/commonWidgets.dart';

class shopView extends StatefulWidget {
  @override
  State<shopView> createState() => _shopViewState();
}

class _shopViewState extends State<shopView> {
  int selectedIndex = 1;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade50,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_back_ios_new_outlined),
            Text("Catagories"),
            Icon(Icons.search),
          ],
        )),
      body: Container(
        decoration: gradientBackground([
          Colors.red.shade100,
          Colors.white,
          Colors.white,
        ]),
        child: listViewWithPadding([


          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 15,bottom: 15),
              child: Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Men"),
                      Text("Women"),
                      Text("Kids"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          categoryCard("New", "asset/images/clothes.png"),
          categoryCard("Shirt", "asset/images/shirt.png"),
          categoryCard("Shoes", "asset/images/shoes.png"),
          categoryCard("Accessories", "asset/images/pic7.png"),

        ]),
      ),
        bottomNavigationBar:bottomNavigationBarWidget(context,selectedIndex)
    );
  }
}
