import 'package:flutter/material.dart';

class UserId {
  final String uid;

  UserId({this.uid});
}

class UserData {
  final String uid;
  final String userName;
  ThemeData themeData = ThemeData.light();

  UserData({this.uid, this.userName});

  void setThemeData(ThemeData theme) {
    themeData = theme;
  }

  ThemeData getThemeData() {
    return themeData;
  }
}
