import 'package:flutter/material.dart';

final List<String> taskDescription = [];
final List<String> taskHeading = [];
TextEditingController taskHeadingController = new TextEditingController();
TextEditingController taskDescriptionController = new TextEditingController();
FocusNode textSecondFocusNode = new FocusNode();

int taskHeaderMaxLenth = 25;
int taskDescriptionMaxLines = 10;
int taskDescriptionMaxLenth;
String deletedtaskHeading = "";
String deletedtaskDescription = "";
