import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Connectivity/viewModel/connectivityViewModel.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';

import '../../commonWidgets/commonWidgets.dart';

class noInternetScreen extends StatefulWidget {
  Function()? onPresse;
  noInternetScreen(this.onPresse , {super.key});

  @override
  State<noInternetScreen> createState() => _noInternetScreenState();
}

class _noInternetScreenState extends State<noInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("No Internet"),
              TextButton(
                onPressed: widget.onPresse,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
    );
  }
}
