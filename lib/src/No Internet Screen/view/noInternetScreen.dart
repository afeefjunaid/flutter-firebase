import 'package:flutter/material.dart';


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
