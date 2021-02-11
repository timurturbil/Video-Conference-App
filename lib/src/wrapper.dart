import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:videocall/model/user.dart';
import 'package:videocall/service/auth.dart';
import 'package:videocall/src/pages/authenticate/authenticate.dart';
import 'package:videocall/src/pages/homescreen.dart';
import 'package:videocall/src/pages/index.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  AuthServices _auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder(
          future: _auth.getCurrentUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            _auth.addDataToDb(user: snapshot.data,);
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return Container();
            }
          });
    }
  }
}
