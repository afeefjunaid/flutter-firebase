import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Connectivity/viewModel/connectivityViewModel.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;

  BaseScaffold({super.key, required this.body, this.bottomNavigationBar,this.appBar});

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  void initState() {
    super.initState();
    connectivityViewModel().initialize();
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<connectivityViewModel>(context).initialize();

    return Scaffold(
      appBar: widget.appBar,
      resizeToAvoidBottomInset: true,
      body: Consumer<connectivityViewModel>(
        builder: (context, connectivity, child) {
          return connectivity.isConnected
              ? widget.body
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("No Internet"),
                TextButton(
                  onPressed: () async {
                    await connectivity.checkConnectivity();
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
