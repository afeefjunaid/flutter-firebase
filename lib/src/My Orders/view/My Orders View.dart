import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';

class myOrdersView extends StatefulWidget {
  const myOrdersView({super.key});

  @override
  State<myOrdersView> createState() => _myOrdersViewState();
}

class _myOrdersViewState extends State<myOrdersView> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: Center(child: Text("My Orders"),));
  }
}
