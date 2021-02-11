import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:videocall/src/pages/search_screen.dart';
import 'package:videocall/src/utils/universal_variables.dart';
import 'package:videocall/widgets/customtile.dart';
import 'package:videocall/service/auth.dart';
import 'package:videocall/model/store_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:videocall/src/pages/authenticate/authenticate.dart';

import 'package:videocall/src/pages/chatscrens/chatscreens.dart';

class CallList extends StatefulWidget {
  @override
  _CallListState createState() => _CallListState();
}

class _CallListState extends State<CallList> {
  AuthServices _auth = AuthServices();
  List<Userlar> userList = [];
  final myController = TextEditingController();
  String name;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var snapshots;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _auth.getCurrentUser().then((User user) {
      _auth.fetchAllUsers(user).then((List<Userlar> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        leading: new Container(
          child: Row(children: <Widget>[
            SizedBox(
              width: 6,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Text("Call List"),
              ],
            )
          ]),
        ),
        actions: <Widget>[
          SizedBox(
            width: 30,
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Text("Sign Out"),
            ],
          ),
          IconButton(
              tooltip: "Sign Out",
              icon: Icon(
                Icons.outbox,
                color: Colors.white,
              ),
              onPressed: () async {
                await _auth.signOut();
                return Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Authenticate()),
                );
              }),
          Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Text("Search"),
            ],
          ),
          IconButton(
              tooltip: "Search",
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              })
        ],
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.lime[400]),
          child: ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              Userlar searchedUser = Userlar(
                  uid: userList[index].uid,
                  profilePhoto: userList[index].profilePhoto,
                  name: userList[index].name,
                  username: userList[index].username);
              return CustomTile(
                mini: false,
                receiver: searchedUser,
                title: Text(
                  "${searchedUser.name}",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Arial", fontSize: 19),
                ),
                leading: Container(
                  constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            NetworkImage("${searchedUser.profilePhoto}"),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: UniversalVariables.onlineDotColor,
                              border: Border.all(
                                  color: UniversalVariables.blackColor,
                                  width: 2)),
                        ),
                      )
                    ],
                  ),
                ),
                subtitle: Text(
                  searchedUser.username,
                  style: TextStyle(color: UniversalVariables.greyColor),
                ),
                onLongPress: () async => {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('isim gir'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  hintText: 'What do people call you?',
                                  labelText: 'Name *',
                                ),
                                controller: myController,
                              )
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Approve'),
                            onPressed: () {
                              users
                                  .doc('${searchedUser.uid}')
                                  .update({'name': '${myController.text}'})
                                  .then((value) => print("User Updated"))
                                  .catchError((error) =>
                                      print("Failed to update user: $error"));
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                },
              );
            },
          ),
        ),
      );
   
  }
}
