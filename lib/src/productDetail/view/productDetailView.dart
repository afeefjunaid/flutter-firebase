import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';
import 'package:productcatalogue/src/commonWidgets/commonWidgets.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';

import '../../home/viewModel/homeViewModel.dart';

class productDetailView extends StatefulWidget {
  dynamic selectedItem;
  productDetailView({super.key, required this.selectedItem,
  });

  @override
  State<productDetailView> createState() => _productDetailViewState();
}

class _productDetailViewState extends State<productDetailView> {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments;
    return BaseScaffold(
        body:
        Container(
      decoration: gradientBackground([
        Colors.red.shade100,
        Colors.white,
        Colors.white,
      ]),
      child: listViewWithPadding([
        Stack(
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.selectedItem.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: Consumer<homeViewModel>(
                    builder: (context, viewModel, child) => IconButton(
                      onPressed: () {
                        viewModel.toggleButton(widget.selectedItem.id - 1);
                      },
                      icon: Icon(
                        viewModel.favouriteStatus[widget.selectedItem.id - 1] ==
                                false
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Wrap(
              children: [
                Text(
                  // splitTitleEveryThreeWords(product.title),
                  widget.selectedItem.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  softWrap: true,
                  maxLines: 2,
                ),
                spacingInHeight(context, 0.03),
                Text("\$${widget.selectedItem.price}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
          ),
        ),
        spacingInHeight(context, 0.02),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Text(
            widget.selectedItem.category,
            style: TextStyle(fontSize: 15),
          ),
        ),
        spacingInHeight(context, 0.01),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: StarRating(
            length: 5,
            starSize: 20,
            color: Colors.yellow[800],
            rating: widget.selectedItem.rating,
          ),
        ),
        spacingInHeight(context, 0.02),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Text(
            "${widget.selectedItem.description}",
            style: TextStyle(fontSize: 20),
          ),
        ),
        spacingInHeight(context, 0.02),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            "ADD TO CART",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        )
      ]),
    ));
  }
}



