import 'package:Ashisu/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Ashisu/screens/calendar.dart';
import 'package:Ashisu/screens/profile.dart';
import 'package:Ashisu/services/auth.dart';
//import 'package:youtube/Service.dart';
//import 'package:youtube/info.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  final usersRef = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  @override
  Widget build(BuildContext context) {
    final User user = auth.currentUser;
    uid = user.uid;
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person, color: Color(0xFF5C0B68)),
            label: Text(
              'Profile',
              style: TextStyle(color: Color(0xFF5C0B68)),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
            SizedBox(height: 30),
            FutureBuilder<DocumentSnapshot>(
              future: usersRef.doc(uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return Text(
                      'Hi ' +
                          data['displayName'].toString() +
                          ', \nChoose your option to continue',
                      style: TextStyle(
                          fontFamily: 'Bebas',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C0B68)),
                      textAlign: TextAlign.center);
                }

                return Container(
                  color: Colors.transparent,
                  child: Center(
                    child: SpinKitChasingDots(
                      color: Color(0xffFFD119),
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/time.gif",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.warning,
                              size: 45,
                              color: Colors.pink[700],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Assistance",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarWidget()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              size: 45,
                              color: Colors.green[700],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Calendar",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.build,
                              size: 45,
                              color: Colors.blue[700],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Towing",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
