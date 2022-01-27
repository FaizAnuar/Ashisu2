import 'dart:ffi';

import 'package:Ashisu/screens/calendar.dart';
import 'package:Ashisu/services/database.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Ashisu/models/event.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Ashisu/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_format/date_format.dart';

class EventEditingPage extends StatefulWidget {
  final Event event;
  const EventEditingPage({
    Key key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  DateTime fromDate;
  DateTime toDate;
  DateTime time;
  DateTime startTime;
  DateTime valu;
  final dateFormatter = DateFormat('dd MMMM yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

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
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 45,
              ),
              buildTitle(),
              SizedBox(
                height: 12,
              ),
              buildDateTimePickers(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return TextFormField(
      maxLength: calHeaderMaxLength,
      controller: reminderHeadingController,
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: '  Add An Event ',
      ),
      // ignore: missing_return
      validator: (String noteHeading) {
        if (noteHeading.isEmpty) {
          return "Please enter Note Heading";
        } else if (noteHeading.startsWith(" ")) {
          return "Please avoid whitespaces";
        }
      },
      onFieldSubmitted: (String value) {
        FocusScope.of(context).requestFocus(textSecondFocusNode);
      },
    );
  }

  buildDateTimePickers() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            color: Colors.transparent,
            child: Text(
              '    From:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 4.0,
          onPressed: () => _selectDate(context),
          child: Container(
            alignment: Alignment.center,
            height: 75.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            size: 18.0,
                            color: Colors.black,
                          ),
                          Text(
                            " ${dateFormatter.format(selectedDate)}",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  "  Change",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 4.0,
          onPressed: () => _selectTime(context),
          child: Container(
            alignment: Alignment.center,
            height: 75.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_alarms_rounded,
                            size: 18.0,
                            color: Colors.black,
                          ),
                          Text(
                            "${selectedTime.hour}:${selectedTime.minute}",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  "  Change",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
        SizedBox(
          height: 20.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            color: Colors.transparent,
            child: Text(
              '    To:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 4.0,
          onPressed: () => _selectTime(context),
          child: Container(
            alignment: Alignment.center,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_alarms_rounded,
                            size: 18.0,
                            color: Colors.teal,
                          ),
                          Text(
                            "${selectedTime.hour}:${selectedTime.minute}",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                  "  Change",
                  style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
        SizedBox(
          height: 60.0,
        ),
        GestureDetector(
          onTap: () {
            if (_formKey.currentState.validate()) {
              setState(() {
                print("in gestrure detector on tap");
                reminderHeading.add(reminderHeadingController.text);
                reminderTime.add(
                    ("${selectedTime.hour}:${selectedTime.minute}").toString());
                reminderDate
                    .add((" ${dateFormatter.format(selectedDate)}").toString());
                reminderHeadingController.clear();

                // tempNote = List.from(noteHeading);
                // tempDesc = List.from(noteDescription);
              });
              print(reminderHeading);
              var firebaseUser = FirebaseAuth.instance.currentUser;
              firestoreInstance.collection("Users").doc(firebaseUser.uid).set({
                "reminderHeading": reminderHeading,
                "selectedReminderTime": reminderTime,
                "reminderDate": reminderDate,
              }, SetOptions(merge: true)).then((_) {
                print("success!");
              });
              Navigator.pop(context);
            }

            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CalendarWidget()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xffff96060)),
            child: Center(
              child: Text(
                "Add Reminder",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
