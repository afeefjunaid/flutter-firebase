import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';
import 'package:productcatalogue/src/Selected%20Category/view/selectedCategoryView.dart';
import 'package:productcatalogue/src/shop/View/shopView.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';
import '../../productDetail/view/productDetailView.dart';
import '../../commonWidgets/commonWidgets.dart';
import '../viewModel/homeViewModel.dart';

class homeScreenView extends StatefulWidget {
  @override
  State<homeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<homeScreenView> {
  final String? category = null;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Container(
        decoration: gradientBackground([
          Colors.red.shade100,
          Colors.white,
          Colors.white,
        ]),
        child: ListView(
          children: [
            buildImageStack("asset/images/pic5.png", "Fashion\nsale",
                onPressed: () {}),
            SizedBox(height: 20),
            buildSectionTitle(""),
             listViewBuilder(category: category),
            SizedBox(height: 15),
            buildImageStack("asset/images/Small banner.png", "Clothes"),
            SizedBox(height: 20),
            buildSectionTitle("Jewelery"),
            listViewBuilder(category: "jewelery"),
            SizedBox(height: 20),
            buildSectionTitle("Electronics"),
            listViewBuilder(category: "electronics"),
            SizedBox(height: 20),
            buildImageStack("asset/images/pic4.png", "New Collection"),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/selectedCategoryView',
                          arguments: "electronics");
                    },
                    child: Stack(
                      children: [
                        Image.asset("asset/images/electronics.jpg",
                            fit: BoxFit.contain),
                        Positioned(
                          bottom: 15,
                          left: 4,
                          child: Text(
                            "Electronics",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/selectedCategoryView',
                          arguments: "jewelery");
                    },
                    child: Stack(
                      children: [
                        Image.asset("asset/images/Jewelry (3).jpg",
                            fit: BoxFit.cover),
                        Positioned(
                          top: 25,
                          left: 14,
                          child: Text(
                            "Jewelry",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                    Navigator.pushNamed(
                    context, '/selectedCategoryView',
                    arguments: "men's clothing");
                    },
                      child: Stack(
                        children: [
                          Image.asset("asset/images/mens clothing.jpg",
                              fit: BoxFit.cover),
                          Positioned(
                            bottom: 25,
                            right: 14,
                            child: Text(
                              "Men's\nClothing",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(
                            context, '/selectedCategoryView',
                            arguments: "women's clothing");
                      },
                      child: Stack(
                        children: [
                          Image.asset("asset/images/women clothing.jpg",
                              fit: BoxFit.cover),
                          Positioned(
                            bottom: 45,
                            left: 4,
                            child: Text(
                              "Women's\nClothing",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          bottomNavigationBarWidget(context, homeViewModelObject.selectedIndex),
    );
  }
}
