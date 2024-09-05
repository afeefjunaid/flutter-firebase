import 'package:flutter/material.dart';

class baseScaffold extends StatefulWidget {
  Widget body;
  Widget? bottomNavigationBar;
  PreferredSizeWidget? appBar;
  baseScaffold({
    required this.body,
    this.bottomNavigationBar,
     this.appBar,
    super.key,

  });

  @override
  State<baseScaffold> createState() => _baseScaffoldState();
}

class _baseScaffoldState extends State<baseScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar
    );
  }
}
