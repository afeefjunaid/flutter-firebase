import 'package:flutter/material.dart';
import 'package:productcatalogue/src/Scaffold/viewModel/scaffoldViewModel.dart';

class myProfileView extends StatefulWidget {
  const myProfileView({super.key});

  @override
  State<myProfileView> createState() => _myProfileViewState();
}

class _myProfileViewState extends State<myProfileView> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(body: Center(child: Text("Coming Soon"),));
  }
}
