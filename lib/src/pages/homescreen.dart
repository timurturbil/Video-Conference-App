import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:videocall/provider/token_provider.dart';
import 'package:videocall/provider/user_provider.dart';
import 'package:videocall/src/pages/callList.dart';
import 'package:videocall/src/pages/callscreens/pickupscreen/pickup_layout.dart';
import 'package:videocall/src/utils/universal_variables.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page = 0;

  UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });

    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Center(child: CallList()),
            Center(
                child: Text(
              "chat ",
              style: TextStyle(color: Colors.white),
            )),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}

/* bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      color: (_page == 0)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Call list",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 0)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ),
/*                 BottomNavigationBarItem(
                  icon: Icon(Icons.call,
                      color: (_page == 1)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "chat",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 1)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ), */
/*               BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone,
                      color: (_page == 2)
                          ? UniversalVariables.lightBlueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 2)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ), */
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ), */
