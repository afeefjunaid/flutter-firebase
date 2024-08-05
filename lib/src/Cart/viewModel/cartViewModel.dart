import 'package:flutter/material.dart';

class cartViewModel extends ChangeNotifier{
  List<dynamic> cartItems=[];
  Map<dynamic,int> countofItems={};
  double totalPrice=0;

  calculatePrice(double p){
    totalPrice+=p;
  }

  clearCart()
  {
    cartItems.clear();
    countofItems.clear();
    notifyListeners();
  }

  int getItemCount(dynamic product) {
    return countofItems[product] ?? 0;
  }

  toggleItem(dynamic prod) {
    if (cartItems.contains(prod)) {
      removeItemsFromCart(prod);
    }
    else {
      addItemToCart(prod);
    }
  }

  addItemToCart(dynamic product){
    if(cartItems.contains(product)){
      countofItems[product] = (countofItems[product] ?? 0) + 1;
    }
    else{
      cartItems.add(product);
      countofItems[product] = 1;
    }
    calculatePrice(product.price);
    notifyListeners();
  }

  deleteItemFromCart(dynamic product){
    print(countofItems[product]);
    calculatePrice(-((product.price)*countofItems[product]));
    cartItems.remove(product);
    countofItems.remove(product);
    notifyListeners();

  }

  removeItemsFromCart(dynamic product) {
    if (cartItems.contains(product)) {
      if (countofItems[product]! > 1) {
        countofItems[product] = countofItems[product]! - 1;
      } else {
        cartItems.remove(product);
        countofItems.remove(product);
      }
      calculatePrice(-product.price);
      notifyListeners();
    }
  }

}

