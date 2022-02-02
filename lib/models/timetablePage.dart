import 'package:flutter/material.dart';

final List<String> taskDescription = [];
final List<String> taskHeading = [];
final List<String> taskTime = [];
final List<String> selection = [];
TextEditingController taskHeadingController = new TextEditingController();
TextEditingController taskDescriptionController = new TextEditingController();
TextEditingController taskTimeController = new TextEditingController();
TextEditingController selectionController = new TextEditingController();

FocusNode textSecondFocusNode = new FocusNode();

int taskHeaderMaxLength = 25;
int taskDescriptionMaxLines = 1;
int taskDescriptionMaxLength = 25;
String deletedTaskHeading = "";
String deletedTaskDescription = "";
String deletedTaskTime = "";
String deletedTaskSelection = "";

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
