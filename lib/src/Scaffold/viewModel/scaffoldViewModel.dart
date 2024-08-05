import 'package:flutter/material.dart';
import 'package:productcatalogue/src/No%20Internet%20Screen/view/noInternetScreen.dart';
import 'package:provider/provider.dart';
import '../../Connectivity/viewModel/connectivityViewModel.dart';
import '../../commonWidgets/commonWidgets.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  BaseScaffold({super.key, required this.body,this.bottomNavigationBar,this.appBar});

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
    connectivityViewModel cc= Provider.of<connectivityViewModel>(context);
    cc.initialize();
    return Scaffold(
      appBar: widget.appBar,
      resizeToAvoidBottomInset: true,
      body: cc.isConnected

          ? Container(
        decoration: gradientBackground([
          Colors.red.shade100,
          Colors.white,
          Colors.white,
          ]),
        child:  widget.body,
      )


          : noInternetScreen((){
        cc.checkConnectivity();
      }),
      bottomNavigationBar : cc.isConnected?widget.bottomNavigationBar :  null,
    );
  }
}
