import 'package:flutter/material.dart';
import 'package:gowallpaper/widgets/title_appbar.dart';
import 'package:provider/provider.dart';
import 'package:gowallpaper/bloc/theme.dart';

class ChangeTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: titleAppBar('Change ', 'Theme')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: Container(
                width: 300,
                height: 50,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.purple[400],
                    child: Text('Light Theme',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _themeChanger.setTheme(ThemeData.light());
                      Navigator.pop(context);
                    }),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 300,
                height: 50,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.purple[400],
                    child: Text('Dark Theme',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _themeChanger.setTheme(ThemeData.dark());
                      Navigator.pop(context);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
