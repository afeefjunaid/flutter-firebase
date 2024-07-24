import 'package:flutter/material.dart';

import '../../Connectivity/viewModel/connectivityViewModel.dart';


class BaseScaffold extends StatefulWidget {
  Widget body;
  Widget? bottomNavigationBar;
  BaseScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          widget.body,
          NetworkStatusDialog(),
        ],
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
