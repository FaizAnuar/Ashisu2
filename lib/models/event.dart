import 'package:flutter/material.dart';
import 'package:Ashisu/shared/constants.dart';

final List<String> reminderHeading = [];
final List<String> reminderTime = [];
final List<String> reminderDate = [];
TextEditingController reminderHeadingController = new TextEditingController();
TextEditingController remTimeController = new TextEditingController();
TextEditingController remDateController = new TextEditingController();

FocusNode textSecondFocusNode = new FocusNode();

int calHeaderMaxLength = 25;
String deletedReminderHeading = "";
String deletedReminderTime = "";
String deletedReminderDate = "";

List<Color> ReminderColor = [
  Colors.yellow[900],
  Colors.purple[500],
  Colors.orange[500],
  Colors.green[900],
  Colors.blue[900],
  Colors.pink[900],
  Colors.indigo[900],
  Colors.red[900],
  Colors.brown[900],
  Colors.teal[900],
];
List<Color> taskMarginColor = [
  Colors.yellow[300],
  Colors.purple[300],
  Colors.orange[300],
  Colors.green[300],
  Colors.blue[300],
  Colors.pink[300],
  Colors.indigo[300],
  Colors.red[300],
  Colors.brown[300],
  Colors.teal[300],
];

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    @required this.title,
    @required this.description,
    @required this.from,
    @required this.to,
    this.backgroundColor = kPrimaryLightColor,
    this.isAllDay = false,
  });
}
