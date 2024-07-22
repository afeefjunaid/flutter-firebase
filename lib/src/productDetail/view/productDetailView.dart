import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productcatalogue/src/commonWidgets/commonWidgets.dart';
import 'package:star_rating/star_rating.dart';

class productDetailView extends StatefulWidget {
  const productDetailView({super.key});

  @override
  State<productDetailView> createState() => _productDetailViewState();
}

class _productDetailViewState extends State<productDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
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
                      image: NetworkImage(
                          "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg"),
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
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mens Casual T-Shirts",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      "\$14.99",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
            spacingInHeight(context, 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Text(
                "Men's clothing",
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
                rating: 3.5,
              ),
            ),
            spacingInHeight(context, 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Text(
                "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
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
