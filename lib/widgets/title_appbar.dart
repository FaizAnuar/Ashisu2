import 'package:flutter/material.dart';

Widget titleAppBar(String txt1, String txt2) {
  return RichText(
    text: TextSpan(children: <TextSpan>[
      TextSpan(
          text: txt1,
          style: TextStyle(
              color: Colors.purple[400],
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Bebas')),
      TextSpan(
          text: txt2,
          style:
              TextStyle(color: Colors.grey, fontSize: 25, fontFamily: 'Bebas')),
    ]),
  );
}
