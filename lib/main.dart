import 'package:Ashisu/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:Ashisu/background.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ashisu',
        routes: {
          '/mypage': (context) => MyPage(),
        },
        initialRoute: '/mypage');
  }
}

// class StreamStart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<UserId>.value(
//       value: AuthService().user,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Wrapper(),
//       ),
//     );
//   }
// }

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Welcome To",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.purple[300],
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Ashisu Mobile",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.green[400],
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  Text(
                    "Seize The Moment",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.grey[100],
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Image.asset(
                "assets/tm3.png",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23.0),
                    color: Color(0xFF4DB6AC)),
                height: 50,
                width: (MediaQuery.of(context).size.width) - 5,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      //MaterialPageRoute(builder: (context) => SelectPage()),
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  color: Colors.transparent,
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final Shader linearGradient1 = LinearGradient(
  colors: <Color>[Color(0xFFFF1000), Color(0xFF2508FF)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
final Shader linearGradient2 = LinearGradient(
  colors: <Color>[Color(0xFF2508FF), Color(0xFFFF1000)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
