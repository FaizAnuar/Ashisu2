import 'dart:ffi';

import 'package:Ashisu/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:Ashisu/models/event.dart';
import 'package:provider/provider.dart';
import 'package:Ashisu/utils.dart';
import 'package:flutter/cupertino.dart';

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
  final titleController = TextEditingController();
  DateTime selectedDate = DateTime.now();
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
  void dispose() {
    titleController.dispose();
    super.dispose();
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
        hintText: '  Add An Event ',
      ),
      onFieldSubmitted: (_) {},
      validator: (title) {
        if (title == null || title.isEmpty) {
          return 'Title cannot be empty';
        }
        return null;
      },
      controller: titleController,
    );
  }

  buildDateTimePickers() {
    return Column(
      children: [
        buildFrom(),
        buildTo(),
      ],
    );
  }

  Widget buildFrom() {
    return buildHeader(
      header: '  From',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(fromDate),
              onClicked: () {
                return pickFromDateTime(pickDate: true);
              },
            ),
          ),
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(fromDate),
              onClicked: () {
                return pickFromDateTime(pickDate: false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTo() {
    return buildHeader(
      header: '  To',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(toDate),
              onClicked: () {},
            ),
          ),
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(toDate),
              onClicked: () {},
            ),
          ),
        ],
      ),
    );
  }

  Future pickFromDateTime({bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
  }

  Future<DateTime> pickDateTime(
    DateTime initialDate, {
    bool pickDate,
    DateTime firstDate,
  }) async {
    if (pickDate) {
      final DateTime date = await showDatePicker(
        context: context,
        firstDate: firstDate ?? DateTime(2019, 8),
        lastDate: DateTime(2101),
        initialDate: DateTime.now(),
      );
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    }
  }
}

Widget buildDropdownField({
  String text,
  VoidCallback onClicked,
}) {
  return ListTile(
    title: Text(text),
    trailing: Icon(Icons.arrow_drop_down),
  );
}

Widget buildHeader({
  String header,
  Widget child,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        header,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      child,
    ],
  );
}
