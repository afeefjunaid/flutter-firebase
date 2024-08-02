import 'package:hive/hive.dart';

import '../My Orders/View Model/My Orders View Model.dart';

part 'hive.g.dart';

@HiveType(typeId: 0)
class myOrders {
  @HiveField(0)
  List<List<myOrdersViewModel>> CombinedList = [];


  myOrders({required this.CombinedList});
}
