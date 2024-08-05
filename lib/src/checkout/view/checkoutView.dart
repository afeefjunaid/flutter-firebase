import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Cart/viewModel/cartViewModel.dart';
import 'package:productcatalogue/src/Order%20Confirmed%20Splash%20Screen/view/Order%20Confirmed%20Splash%20Screen.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';
import 'package:productcatalogue/src/Stripe%20Payment/viewModel/stripePaymentViewModel.dart';
import 'package:productcatalogue/src/commonWidgets/commonWidgets.dart';
import 'package:provider/provider.dart';
import '../../My Orders/View Model/My Orders View Model.dart';

class checkoutView extends StatefulWidget {
  const checkoutView({super.key});

  @override
  State<checkoutView> createState() => _checkoutViewState();
}

class _checkoutViewState extends State<checkoutView> {
  double deliveryCharges=0.15;

  TextEditingController addressController=TextEditingController();
  TextEditingController contactController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: 10, bottom: 10, right: 20, left: 20),
          child: ListView(children:[
            buildSectionTitle("Shipping Address"),
            Wrap(
              children: [
                TextFormField(
                  maxLines: 3,
                controller: addressController,
                decoration: InputDecoration(

                  hintText: "Enter Your Shipping Address",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),]
            ),
            spacingInHeight(context, 0.02),
            buildSectionTitle("Contact Information"),
            buildTextFormField("Enter Your Contact Info",contactController),
            spacingInHeight(context, 0.28),
            Consumer<cartViewModel>(
              builder: (context,cvm,child) {
                return
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order", style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w800)),
                          Text("\$${cvm.totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delivery(${(deliveryCharges*100).toStringAsFixed(0)}%)", style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w800)),
                          Text("\$${(cvm.totalPrice*deliveryCharges).toStringAsFixed(2)}", style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Summary", style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w800)),
                          Text("\$${((cvm.totalPrice*deliveryCharges)+(cvm.totalPrice)).toStringAsFixed(2)}", style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w800)),
                        ],

                      ),
                      buildButton("Pay", () async {
                       var res= await stripePaymentViewModel.paymentInstance.createPaymentIntent(((cvm.totalPrice*deliveryCharges)+(cvm.totalPrice)), "usd");
                        myOrdersViewModel().combineList(cvm.cartItems,cvm.countofItems);
                        if(res!=null) {
                          cvm.clearCart();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>orderConfirmedSplashScreen()));
                        }

                      })
                    ],

                  );
              }
            )
          ]
          ),
        )
    );
  }
}
