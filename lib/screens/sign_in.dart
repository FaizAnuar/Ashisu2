import 'package:Ashisu/models/NotesPage.dart';
import 'package:Ashisu/models/timetablePage.dart';
import 'package:Ashisu/screens/register.dart';
import 'package:Ashisu/screens/select.dart';
import 'package:Ashisu/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:Ashisu/shared/loading.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final usersRef = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.amber[200],
            body: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(''), fit: BoxFit.cover)),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Stack(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 100),
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
                              "assets/clock.png",
                              width: 500.0,
                              height: 240.0,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
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
                              validator: (val) => val.length < 6
                                  ? 'Password must be 6 characters long'
                                  : null,
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: 20),
                            RaisedButton(
                              color: Colors.purple[400],
                              child: Text(
                                'Sign in',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                // if (_formKey.currentState.validate()) {
                                //   setState(() => loading = true);
                                //   dynamic result =
                                //       await _auth.signInWithEmailAndPassword(
                                //           email, password);
                                //   if (result == null) {
                                //     setState(() {
                                //       error =
                                //           'Could not sign in. Please try again';
                                //       loading = false;
                                //     });
                                //   }
                                //   if (result != null) {
                                //     _auth.signInWithEmailAndPassword(
                                //         email, password);
                                //   }
                                // }
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                                  String useremail =
                                      _auth.currentUser.email.toString();

                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .where('email', isEqualTo: useremail)
                                      .snapshots()
                                      .listen((data) {
                                    setState(() {
                                      //insert data
                                      User user = _auth.currentUser;
                                      String uid = user.uid;
                                      getNotesArr(uid);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectPage()));
                                    });
                                  });
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    loading = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Ops! Login Failed"),
                                      content: Text('${e.message}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text('Okay'),
                                        )
                                      ],
                                    ),
                                  );
                                  print("login fail");
                                }
                              },
                            ),
                            SizedBox(height: 12.0),
                            Text(error,
                                style: TextStyle(
                                    color: Colors.red[100], fontSize: 14)),
                            _createAccountLabel()
                          ],
                        ),
                      ),
                    ),
                    CustomPaint(painter: CurvePainter()),
                  ],
                )));
  }

  void getNotesArr(String uid) async {
    await usersRef.doc(uid).get().then((value) {
      //'value' is the instance of 'DocumentSnapshot'
      //'value.data()' contains all the data inside a document in the form of 'dictionary'
      var fields = value.data();
      print(fields['noteHeading'].length);

      //Using 'setState' to update the user's data inside the app
      //firstName, lastName and title are 'initialised variables'
      int index = 0;
      for (int i = fields['noteHeading'].length; i > 0; i--) {
        noteHeading.add(fields['noteHeading'][index]);
        noteDescription.add(fields['noteDescription'][index]);
        taskHeading.add(fields['taskHeading'][index]);
        taskDescription.add(fields['taskDescription'][index]);
        taskTime.add(fields['selectedTime'][index]);
        selection.add(fields['urgency'][index]);

        index++;
      }
      print(noteHeading);
    });
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Register()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Bebas', color: Colors.black),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Register',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Bebas', color: kPrimaryLightColor),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill; // Change this to fill
    var path = Path();
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
