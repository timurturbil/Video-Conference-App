/* import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fluttervideo/model/call_model.dart';
import 'package:fluttervideo/src/pages/callscreens/call_screens.dart';
import 'package:fluttervideo/src/pages/callscreens/pickupscreen/pickup_screen.dart';

import 'package:http/http.dart' as http;
 */
/* Future<Album> fetchAlbum() async {
  final response = await http.get(
      'https://smstimur.herokuapp.com/access_token?channel=test&uid=1234');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var a = Album.fromJson(jsonDecode(response.body));
    var b = a.token.toString();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
} */

class Album {
  final String token;

  Album({this.token});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      token: json['token'],
    );
  }
}
/* 
class MyAppp extends StatefulWidget {
  final ClientRole role;
  final Call call;
  MyAppp({@required this.call, this.role});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppp> {
  Future<Album> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                
                
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
 */