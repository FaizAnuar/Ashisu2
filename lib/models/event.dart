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
String deletedCalHeading = "";
String deletedReminderTime = "";
String deletedReminderDate = "";

List<Color> taskColor = [
  Colors.green[900],
  Colors.blue[900],
  Colors.pink[900],
  Colors.orange[900],
  Colors.indigo[900],
  Colors.red[900],
  Colors.yellow[900],
  Colors.brown[900],
  Colors.teal[900],
  Colors.purple[900],
];
List<Color> taskMarginColor = [
  Colors.green[500],
  Colors.blue[500],
  Colors.pink[500],
  Colors.orange[500],
  Colors.indigo[500],
  Colors.red[500],
  Colors.yellow[500],
  Colors.brown[500],
  Colors.teal[500],
  Colors.purple[500],
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
