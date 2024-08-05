
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class myOrdersViewModel extends ChangeNotifier {
  final dynamic name;
  final dynamic value;

  myOrdersViewModel({
    this.name, this.value
  });


  
  List<List<myOrdersViewModel>> CombinedList = [];

  Future<void> combineList(List<dynamic> cartItems, Map<dynamic, int> countofItems) async {
    List<myOrdersViewModel> orderList = [];
    for (var item in cartItems) {
      if (countofItems.containsKey(item)) {
        int count = countofItems[item]!;
        orderList.add(myOrdersViewModel(name: item, value: count));
      }
    }
    var localDb=Hive.box('myOrdersBox');
    CombinedList.add(orderList);

    // myOrder.add(CombinedList);

    await localDb.put("Order List", orderList);
   print( await localDb.get("Order List"));
    // if(localDb.isEmpty){
    //
    // }
    // myOrder.add(orderList);
    //
    // print(myOrder);
  }
}