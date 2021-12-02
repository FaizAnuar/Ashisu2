import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2)));

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

showAlertDialog(BuildContext context, String msg, String msg2) {
  String passMsg = msg;
  String passMsg2 = msg2;
  AlertDialog alert = AlertDialog(
    title: Text(passMsg, style: TextStyle(fontSize: 16)),
    content: Text(passMsg2, style: TextStyle(color: Colors.grey)),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
