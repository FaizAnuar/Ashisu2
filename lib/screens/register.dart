import 'package:Ashisu/models/NotesPage.dart';
import 'package:Ashisu/models/timetablePage.dart';
import 'package:Ashisu/models/user.dart';
import 'package:Ashisu/screens/select.dart';
import 'package:Ashisu/screens/sign_in.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Ashisu/services/auth.dart';
import 'package:Ashisu/shared/loading.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

enum SingingCharacter { lafayette, jefferson }

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String uid;

  //text field state
  String userName = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.amber[200],
            body: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 50),
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "ASH",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                    fontFamily: 'Bebas')),
                            TextSpan(
                                text: "ISU",
                                style: TextStyle(
                                    color: kPrimaryLightColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50,
                                    fontFamily: 'Bebas')),
                          ]),
                        ),
                        SizedBox(height: 20),
                        Image.asset(
                          "assets/manage.png",
                          width: 500.0,
                          height: 240.0,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'User Name'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter your User Name' : null,
                          onChanged: (val) {
                            setState(() => userName = val);
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter your e-mail' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          obscureText: true,
                          validator: (val) => val.length < 6
                              ? 'Password must be 6 characters long'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                          color: Colors.purple[400],
                          child: Text(
                            'Register Now',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              try {
                                setState(() {
                                  loading = true;
                                });
                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                User user = _auth.currentUser;
                                uid = user.uid;
                                if (newUser != null) {
                                  //send firebase
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(uid)
                                      .set({
                                    'email': email,
                                    'displayName': userName,
                                    'noteHeading': noteHeading,
                                    'noteDescription': noteDescription,
                                    'taskHeading': taskHeading,
                                    'taskDescription': taskDescription,
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Successfully Register!",
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignIn()));
                                }
                                setState(() {
                                  loading = false;
                                });
                              } catch (e) {
                                print(e.message);
                              }
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
                        Text(error,
                            style: TextStyle(
                                color: Colors.red[200], fontSize: 14)),
                        _createAccountLabel()
                      ],
                    ),
                  ),
                )));
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Bebas', color: Colors.black),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Log In',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Bebas', color: kPrimaryLightColor),
            ),
          ],
        ),
      ),
    );
  }
}
