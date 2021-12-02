import 'package:flutter/material.dart';
import 'package:gowallpaper/bloc/theme.dart';
import 'package:gowallpaper/screens/select.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:gowallpaper/widgets/title_appbar.dart';

class Fingerprint extends StatelessWidget {
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      theme: theme.getTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.purple[400],
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: titleAppBar('Touch ', 'ID'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () async {
            bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

            if (weCanCheckBiometrics) {
              bool authenticated = await localAuth.authenticateWithBiometrics(
                localizedReason: "Authenticate to see your wallet ",
              );

              if (authenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectPage(),
                  ),
                );
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.fingerprint,
                size: 124.0,
              ),
              Text(
                "Touch to Continue",
                style: TextStyle(
                  fontSize: 50,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
