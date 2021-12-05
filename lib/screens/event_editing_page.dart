import 'package:flutter/material.dart';
import 'package:gowallpaper/models/event.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
