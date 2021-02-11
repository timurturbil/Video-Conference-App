import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:videocall/src/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  SpinKitCubeGrid spinkit;

  @override
  void initState() {
    super.initState();

    spinkit = SpinKitCubeGrid(
      color: Colors.white,
      size: 50.0,
      controller: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 3000)),
    );

    new Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Wrapper()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 100, 0, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            spinkit,
            SizedBox(
              height: 25,
            ),
            Text(
              "Welcome",
              style: GoogleFonts.nunito(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
