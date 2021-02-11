import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:videocall/fetch_data.dart';
import 'package:videocall/model/user.dart';
import 'package:videocall/provider/token_provider.dart';
import 'package:videocall/provider/user_provider.dart';
import 'package:videocall/service/auth.dart';
import 'package:videocall/src/pages/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:videocall/src/pages/authenticate/register.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Users>.value(
          value: AuthServices().usert,
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Splash(),
      ),
    );
  }
}
