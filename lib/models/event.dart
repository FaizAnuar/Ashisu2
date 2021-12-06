import 'package:flutter/material.dart';
import 'package:Ashisu/shared/constants.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Event({
    this.title,
    this.description,
    this.from,
    this.to,
    this.backgroundColor = kPrimaryLightColor,
    this.isAllDay = false,
  });
}
