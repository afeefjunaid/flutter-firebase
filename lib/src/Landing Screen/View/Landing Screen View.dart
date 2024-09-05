import 'package:chatapp/src/Base%20Scaffold/View/Base%20Scaffold%20View.dart';
import 'package:chatapp/src/Comming%20soon%20Screen/Comming%20Soon.dart';
import 'package:chatapp/src/Single%20Chats/View/Single%20Chats%20View.dart';
import 'package:flutter/material.dart';

class landingScreenView extends StatefulWidget {
  const landingScreenView({super.key});

  @override
  State<landingScreenView> createState() => _landingScreenViewState();
}

class _landingScreenViewState extends State<landingScreenView> {
  List<dynamic> screen = [
    chatView(),
    comingSoon(),
    comingSoon(),
    comingSoon(),
  ];
  int ind = 0;
  getScreen(int index) {
    return screen[index];
  }

  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      body:getScreen(ind),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(label: "Chat", icon: Icon(Icons.chat)),
          BottomNavigationBarItem(label: "Group", icon: Icon(Icons.group)),
          BottomNavigationBarItem(label: "Camera", icon: Icon(Icons.camera)),
          BottomNavigationBarItem(label: "Setting", icon: Icon(Icons.settings)),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 30,
        currentIndex: ind,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: (int index){
          ind=index;
          setState(() {

          });

        },

      ),
    );
  }
}
