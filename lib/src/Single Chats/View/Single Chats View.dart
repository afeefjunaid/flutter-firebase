import 'package:chatapp/src/Authentication/View%20Model/Authentication%20View%20Model.dart';
import 'package:chatapp/src/Base%20Scaffold/View/Base%20Scaffold%20View.dart';
import 'package:chatapp/src/Common%20Widgets/View/Common%20Widgets%20View.dart';
import 'package:chatapp/src/Selected%20Chat/View/Selected%20Chat%20View.dart';
import 'package:flutter/material.dart';

class chatView extends StatefulWidget {
  const chatView({super.key});

  @override
  State<chatView> createState() => _chatViewState();
}

class _chatViewState extends State<chatView> {
  @override
  Widget build(BuildContext context) {
    return baseScaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chats",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600,color: Colors.green),
              ),
              Icon(
                Icons.text_snippet_outlined,
                size: 30,
              )
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: dbInst
                .where('uid', isNotEqualTo: authInst.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No Data"));
              }
              var users = snapshot.data!;
              return ListView.builder(
                itemCount: users.docs.length,
                itemBuilder: (context, index) {
                  var user = users.docs[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => selectedChatView(
                                  selectedUser: users.docs[index])));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(user['name'][0].toUpperCase()),
                      ),
                      title: Text(
                        user['name'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              );
            },
          )),
          buttonWidget("Signout", () {
            authenticationViewModel().signout(context);
          })
        ],
      ),
    );
  }
}
