import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Favourites/view/favouritesModel.dart';
import 'package:productcatalogue/src/My%20Orders/view/My%20Orders%20View.dart';
import 'package:productcatalogue/src/My%20Profile/view/My%20Profile%20View.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';

import '../../Cart/view/cartView.dart';
import '../../home/view/homeScreenView.dart';
import '../../login/view/loginView.dart';
import '../../shop/View/shopView.dart';

class landingScreen extends StatefulWidget {
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool showBottomNavigationBar;
  landingScreen(
      {super.key,
      this.bottomNavigationBar,
      this.appBar,
      this.showBottomNavigationBar = false});

  @override
  State<landingScreen> createState() => _landingScreenState();
}

class _landingScreenState extends State<landingScreen> {
  List<Widget> Screens = [
    homeScreenView(),
    shopView(),
    cartView(),
    favouritesView(),
    myProfileView(),
    myOrdersView(),
  ];

  void onItemTapped(int index) {
    Screens[index];
    setState(() {
      selectedIndex = index;
    });
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        body: Screens[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Bag',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Favourites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: 'My Orders',
              ),
            ],
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: selectedIndex,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.red,
            onTap: onItemTapped));
  }
}
