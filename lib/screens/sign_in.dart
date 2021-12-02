import 'package:gowallpaper/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:gowallpaper/shared/constants.dart';
import 'package:gowallpaper/shared/loading.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
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
            backgroundColor: Color(0xFF5C0B68),
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
                                    text: "CAR",
                                    style: TextStyle(
                                        color: Color(0xffFFD119),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                        fontFamily: 'Bebas')),
                                TextSpan(
                                    text: "OSAK",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                        fontFamily: 'Bebas')),
                              ]),
                            ),
                            SizedBox(height: 55),
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
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not sign in. Please try again';
                                      loading = false;
                                    });
                                  }
                                  if (result != null) {
                                    _auth.signInWithEmailAndPassword(
                                        email, password);
                                  }
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
                    ),CustomPaint(painter: CurvePainter()),
                  ],
                )));
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () => widget.toggleView(),
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
                  fontSize: 13, fontFamily: 'Bebas', color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Register',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Bebas', color: Color(0xffFFD119)),
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
  @override bool shouldRepaint(CustomPainter oldDelegate) { return true; } 
}
