import 'package:flutter/material.dart';

class TestTest extends StatelessWidget {
  final String payload;

  const TestTest({key, this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              payload ?? '',
              textAlign: TextAlign.center,
            ),
            Text(
              'PAYLOAD',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
