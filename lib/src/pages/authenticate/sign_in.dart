import 'package:flutter/material.dart';
import 'package:videocall/service/auth.dart';
import 'package:videocall/src/pages/callList.dart';
import 'package:videocall/src/pages/authenticate/authenticate.dart';
import 'package:videocall/src/pages/authenticate/register.dart';

/* import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger; */
class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          leading: new Container(),
          elevation: 0.0,
          title: Text('Login Screen '),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () {/* 
                return Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
               */},
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    validator: (val) => val.length < 6
                        ? 'Enter a password 6+ chars long'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result =
                              await _auth.signInWithEmailandPassaword(
                                  email.trim(), password.toString());
                          if (result == null) {
                            setState(() {
                              error =
                                  "could not sign in with those credentials";
                            });
                          }
                        }
                      }),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign In with Facebook',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await _auth.handleLogin();

                      }),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign In with Google',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await _auth.signInWithGoogle();


                      }),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
