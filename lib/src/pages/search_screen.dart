import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:videocall/model/store_user.dart';
import 'package:videocall/service/auth.dart';
import 'package:videocall/src/pages/callscreens/pickupscreen/pickup_screen.dart';
import 'package:videocall/src/pages/chatscrens/chatscreens.dart';
import 'package:videocall/src/utils/universal_variables.dart';
import 'package:videocall/widgets/customtile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthServices _auth = AuthServices();
  List<Userlar> userList = [];
  String query = "";
  TextEditingController searchController = TextEditingController();
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

  buildSuggestions(String query) {
    final List<Userlar> suggestionList = query.isEmpty
        ? []
        : userList.where((Userlar user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUserName = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUserName || matchesName);
          }).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          Userlar searchedUser = Userlar(
              uid: suggestionList[index].uid,
              profilePhoto: suggestionList[index].profilePhoto,
              name: suggestionList[index].name,
              username: suggestionList[index].username);
          return CustomTile(
            mini: false,
            receiver: searchedUser,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.profilePhoto),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              searchedUser.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              searchedUser.name,
              style: TextStyle(color: UniversalVariables.greyColor),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: (val) {
            setState(() {
              query = val;
            });
          },
          cursorColor: UniversalVariables.blackColor,
          autofocus: true,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 35,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => searchController.clear());
              },
            ),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color(0x88ffffff),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
}
