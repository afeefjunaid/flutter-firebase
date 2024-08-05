
import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Cart/viewModel/cartViewModel.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';
import 'package:productcatalogue/src/checkout/view/checkoutView.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../commonWidgets/commonWidgets.dart';
import '../../productDetail/view/productDetailView.dart';

class cartView extends StatefulWidget {
  const cartView({super.key});

  @override
  State<cartView> createState() => _cartViewState();
}

class _cartViewState extends State<cartView> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Cart")),
      ),
        body: Consumer<cartViewModel>(builder: (context, c, child) {
      return c.cartItems.isNotEmpty
          ? Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: c.cartItems.length,
                  itemBuilder: (context, index) {
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
                                        selectedItem: c.cartItems[index],
                                        heroTag: nId,
                                      )));
                        },
                        child: Stack(clipBehavior: Clip.none, children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20),
                            child: Card(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(c.cartItems[index].image,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(c.cartItems[index].title,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 18)),
                                          ),
                                          Text("${c.cartItems[index].category}",
                                              style: TextStyle(fontSize: 15)),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              "\$${c.cartItems[index].price}",
                                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                                            ),
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
                              right: 60,
                              bottom: 10,
                              child: IconButton(
                                onPressed: () {
                                  c.addItemToCart(c.cartItems[index]);
                                },
                                icon: Icon(Icons.add),
                              )),
                          Positioned(
                              right: 60,
                              bottom: 25,
                              child: Text("${c.getItemCount(c.cartItems[index])}")),
                          Positioned(
                              right: 15,
                              bottom: 18,
                              child: IconButton(
                                onPressed: () {
                                  c.removeItemsFromCart(c.cartItems[index]);
                                },
                                icon: Icon(Icons.minimize),
                              )),
                          Positioned(
                              top: 2,
                              right: 12,
                              child: IconButton(
                                onPressed: () {
                                  c.deleteItemFromCart(c.cartItems[index]);
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
                )),
                Padding(
                  padding:  EdgeInsets.only(
                      top: 10, bottom: 10, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800)),
                      Text("\$${c.totalPrice.toStringAsFixed(2)}",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                buildButton("Checkout",(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>checkoutView()));
                })
              ],
            )
          : Center(child: Text("No Items Added To Cart"));
    }));
  }
}
