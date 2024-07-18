import 'package:adminpanel/src/common_Widgets/Common_Widget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class businessDetailsPage extends StatefulWidget{
  @override
  State<businessDetailsPage> createState() => _businessDetailsState();
}

class _businessDetailsState extends State<businessDetailsPage>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Business Details"),
    );
  }
}