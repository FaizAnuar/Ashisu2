import 'dart:ffi';

import 'package:Ashisu/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:Ashisu/models/event.dart';
import 'package:provider/provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event event;
  const EventEditingPage({
    key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime fromDate;
  DateTime toDate;

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        leading: CloseButton(color: kPrimaryColor),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() {
    return [
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {},
        icon: Icon(
          Icons.done,
          color: kPrimaryColor,
        ),
        label: Text(
          'Save',
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
    ];
  }

  Widget buildTitle() {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
      ),
      onFieldSubmitted: (_) {},
    );
  }
}
