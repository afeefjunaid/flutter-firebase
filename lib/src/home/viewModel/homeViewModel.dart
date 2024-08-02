import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../API/apiClient.dart';
import '../model/homeScreenModel.dart';
homeViewModel homeViewModelObject=homeViewModel();


class homeViewModel extends ChangeNotifier {
  int selectedIndex = 0;
  bool buttonState = true;
  late Future futureProducts;
  List<dynamic> favouriteProducts=[];

  homeViewModel() {
    futureProducts = fetchProducts();
  }

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void toggleButton(dynamic obj) {

    if(!favouriteProducts.contains(obj)) {
        favouriteProducts.add(obj);
    }
    else{
      favouriteProducts.remove(obj);
    }
    notifyListeners();
  }

   Future fetchProducts() async {
     final response =await ApiClient.getRequest('products');
       if(response.statusCode==200) {
         List<dynamic> data=json.decode(response.body);
         return data.map((json)=>homeScreenModel.fromJson(json)).toList();
       }
       else if (response.statusCode == 404){
         throw "Error: Resource not found ${response.statusCode}. Check your URL.";
       }
       else {
         throw Exception('Error: Failed to load data, status code: ${response.statusCode}');
       }
  }
}
