import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';
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
            buildSectionTitle("Random"),
            Consumer<homeViewModel>(builder: (context, viewModel, child) {
              return FutureBuilder(
                future: homeViewModelObject.futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  } else {
                    final products = snapshot.data!;
                    return Container(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          double rate = products[index].rating ?? 0.0;
                          return Container(
                            width: 150,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => productDetailView(
                                            selectedItem: products[index])));
                              },
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(clipBehavior: Clip.none, children: [
                                      Image.network(products[index].image,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover),
                                      Positioned(
                                        right: 2,
                                        bottom: -13,
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              viewModel.toggleButton(index);
                                            },
                                            icon: Icon(
                                              viewModel.favouriteStatus[
                                                          index] ==
                                                      false
                                                  ? Icons.favorite
                                                  : Icons
                                                      .favorite_border_outlined,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, top: 10),
                                      child: Text(products[index].title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, top: 5),
                                      child: StarRating(
                                        length: 5,
                                        rating: rate,
                                        color: Colors.yellow[800],
                                        starSize: 16,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, top: 5),
                                      child: Text("${products[index].price}\$"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            }),
            SizedBox(height: 15),
            buildImageStack("asset/images/Small banner.png", "Clothes"),
            SizedBox(height: 20),
            buildSectionTitle("Sale"),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          productDetailView(selectedItem: null)),
                );
              },
              child: buildHorizontalScrollView(
                "asset/images/photo2.png",
                "asset/images/photo3.png",
                "T Shirts",
                "Casual Shirts",
                "14.99\$",
                "15.99\$",
                true,
                3,
                3.5,
                buttonState: homeViewModelObject.buttonState,
                toggleButton: homeViewModelObject.toggleButton,
              ),
            ),
            SizedBox(height: 20),
            buildSectionTitle("New"),
            buildHorizontalScrollView(
              "asset/images/photo1.png",
              "asset/images/pic8.png",
              "Plain Shirts",
              "Long Dress",
              "29.99\$",
              "22.99\$",
              false,
              4,
              5,
              buttonState: homeViewModelObject.buttonState,
              toggleButton: homeViewModelObject.toggleButton,
            ),
            SizedBox(height: 20),
            buildImageStack("asset/images/pic4.png", "New Collection"),
            buildTwoColumnImages(),
          ],
        ),
      ),
      bottomNavigationBar:
          bottomNavigationBarWidget(context, homeViewModelObject.selectedIndex),
    );
  }
}
