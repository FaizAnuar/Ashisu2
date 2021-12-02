import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gowallpaper/bloc/theme.dart';

import 'package:gowallpaper/screens/wrapper.dart';
import 'package:gowallpaper/models/user.dart';
import 'package:gowallpaper/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.light()),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ashisu',
          routes: {
            '/mypage': (context) => MyPage(),
          },
          initialRoute: '/mypage'),
    );
  }
}

class StreamStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserId>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/career2.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Image.asset('assets/career2.jpeg').color,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: ListTile(
            trailing: Icon(
              Icons.clear_all,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Ashisu Mobile",
                  style: TextStyle(
                      color: Color(0xFFFFD119),
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Daily Assistance",
                  style: TextStyle(
                      color: Color(0xFFFFD119),
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    Text(
                      "WE'LL BE THERE FOR YOU",
                      style: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/carmovingcolor.gif",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23.0),
                      color: Color(0xFFFFD119)),
                  height: 50,
                  width: (MediaQuery.of(context).size.width) - 5,
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        //MaterialPageRoute(builder: (context) => SelectPage()),
                        MaterialPageRoute(builder: (context) => StreamStart()),
                      );
                    },
                    color: Colors.transparent,
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Color(0xFF5C0B68),
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
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
