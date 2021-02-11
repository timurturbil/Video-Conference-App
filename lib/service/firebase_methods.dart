import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:videocall/model/store_user.dart';
import 'package:videocall/src/utils/utilities.dart';
import 'package:videocall/fetch_data.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection =
      firestore.collection("users");
  //user class
  Userlar user = Userlar();

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }


  Future<Userlar> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();

    return Userlar.fromMap(documentSnapshot.data());
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser, {String name}) async {
    String username = Utils.getUsername(currentUser.email);

    user = Userlar(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName ?? name,
        profilePhoto: currentUser.photoURL ?? 'https://lh3.googleusercontent.com/-rm65tl5MnZc/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucle0wW0MxGc2euJwDMX5YpFQVQSKw/s96-c/photo.jpg',
        username: username);

    firestore.collection("users").doc(currentUser.uid).set(user.toMap(user));
  }

  Future<List<Userlar>> fetchAllUsers(User currentUser) async {
    List<Userlar> userList = [];

    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(Userlar.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }
}
