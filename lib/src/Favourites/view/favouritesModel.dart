
import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Cart/viewModel/cartViewModel.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';
import 'package:productcatalogue/src/home/viewModel/homeViewModel.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';
import 'package:uuid/uuid.dart';

import '../../productDetail/view/productDetailView.dart';

class favouritesView extends StatefulWidget {
  favouritesView({super.key});

  @override
  State<favouritesView> createState() => _favouritesModelViewState();
}

class _favouritesModelViewState extends State<favouritesView> {
  bool toggleBuilder = true;


  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: AppBar(
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 18.0),
                child: IconButton(
                  onPressed: () {
                    if (toggleBuilder) {
                      toggleBuilder = false;
                      setState(() {});
                    } else {
                      toggleBuilder = true;
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.menu),
                ))
          ],
          title: Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Center(
              child: Text("Favourites"),
            ),
          ),
        ),
        body: toggleBuilder
            ? Consumer<homeViewModel>(
                builder: (context, hh, child) {
                  return hh.favouriteProducts.isNotEmpty
                      ? ListView.builder(
                          itemCount: hh.favouriteProducts.length,
                          itemBuilder: (context, index) {
                            double rate = hh.favouriteProducts[index].rating ?? 0.0;
                            Uuid id = Uuid();
                            var nId = id.v4();
                            return Container(
                              width: 150,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              productDetailView(
                                                selectedItem:
                                                    hh.favouriteProducts[index],
                                                heroTag: nId,
                                              )));
                                },
                                child:
                                    Stack(clipBehavior: Clip.none, children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        right: 20,
                                        left: 20),
                                    child: Card(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                              hh.favouriteProducts[index].image,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      hh
                                                          .favouriteProducts[
                                                              index]
                                                          .title,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18)),
                                                  Text(
                                                      "${hh.favouriteProducts[index].category}",
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                  StarRating(
                                                    length: 5,
                                                    rating: rate,
                                                    color: Colors.yellow[800],
                                                    starSize: 16,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                  ),
                                                  Text(
                                                    "\$${hh.favouriteProducts[index].price}",
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 20,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Consumer<cartViewModel>(
                                        builder: (context,cm,child){
                                          return IconButton(
                                            onPressed: () {
                                              cm.toggleItem(hh.favouriteProducts[index]);
                                            },
                                            icon: cm.cartItems.contains(hh.favouriteProducts[index])? Icon(
                                              Icons.shopping_bag,
                                              color: Colors.white,
                                              size: 20,
                                            ):Icon(
                                              Icons.shopping_bag_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          );
                                        },
                                      )


                                    ),
                                  ),
                                  Positioned(
                                      top: 2,
                                      right: 12,
                                      child: IconButton(
                                        onPressed: () {
                                          hh.toggleButton(
                                              hh.favouriteProducts[index]);
                                        },
                                        icon: Icon(
                                          Icons.dangerous_outlined,
                                          color: Colors.red,
                                        ),
                                      )),
                                ]),
                              ),
                            );
                          },
                        )
                      : Center(child: Text("No Favourite Products"));
                },
              )
            : Consumer<homeViewModel>(
                builder: (context, hh, child) {
                  return hh.favouriteProducts.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: hh.favouriteProducts.length,
                            itemBuilder: (context, index) {
                              double rate =
                                  hh.favouriteProducts[index].rating ?? 0.0;
                              Uuid id = Uuid();
                              var nId = id.v4();
                              return Container(
                                width: 150,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => productDetailView(
                                          selectedItem:
                                              hh.favouriteProducts[index],
                                          heroTag: nId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                hh.favouriteProducts[index]
                                                    .image,
                                                height: 150,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0, top: 10),
                                              child: Text(
                                                hh.favouriteProducts[index]
                                                    .title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
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
                                                  left: 5, top: 5),
                                              child: Text(
                                                  "${hh.favouriteProducts[index].price}\$"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          top: -8,
                                          right: -6,
                                          child: IconButton(
                                            onPressed: () {
                                              hh.toggleButton(
                                                  hh.favouriteProducts[index]);
                                            },
                                            icon: Icon(
                                              Icons.dangerous_outlined,
                                              color: Colors.red,
                                            ),
                                          )),
                                      Consumer<homeViewModel>(
                                        builder: (context, viewModel, child) {
                                          return Positioned(
                                            right: 5,
                                            bottom: 80,
                                            child: InkWell(
                                              onTap: () {
                                                viewModel.toggleButton(hh
                                                    .favouriteProducts[index]
                                                    .title);
                                              },
                                              child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child:
                                                      Consumer<cartViewModel>(
                                                    builder:
                                                        (context, c, child) {
                                                      return IconButton(
                                                        onPressed: () {
                                                          c.cartItems.add(
                                                              hh.favouriteProducts[
                                                                  index]);
                                                        },
                                                        icon: Icon(
                                                          Icons.shopping_bag,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    },
                                                  )),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(child: Text("No Favourite Products"));
                },
              ));
  }
}
