import 'dart:ffi';

import 'package:Ashisu/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:Ashisu/models/event.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Ashisu/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_time_picker/date_time_picker.dart';

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
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  DateTime fromDate;
  DateTime toDate;
  DateTime time;
  DateTime startTime;
  DateTime valu;
  final dateFormatter = DateFormat('dd MMMM yyyy');

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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 4.0,
          onPressed: () {
            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'dd MMMM yyyy',
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(1940),
              lastDate: DateTime.now().add(Duration(days: 1)),
              // icon: Icon(Icons.event),
              // dateLabelText: 'Date',
              // timeLabelText: "Hour",
              onChanged: (valB) {
                fromDate = DateFormat("dd MMMM yyyy")
                    .format(DateTime.parse(valB)) as DateTime;
              },
              validator: (valB) {
                return valB;
              },
              onSaved: (valB) {
                fromDate = DateFormat("dd MMMM yyyy")
                    .format(DateTime.parse(valB)) as DateTime;
              },
            );
          },
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
                            Icons.date_range,
                            size: 18.0,
                            color: Colors.teal,
                          ),
                          Text(
                            " $fromDate",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
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
          height: 20.0,
        ),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 4.0,
          onPressed: () {
            DateTimePicker(
              type: DateTimePickerType.time,
              initialValue: " ",
              locale: Locale('ms', 'MY'),
              onChanged: (value) {
                startTime = value as DateTime;
              },
              validator: (value) {
                return value;
              },
              onSaved: (value) {
                startTime = value as DateTime;
              },
            );
          },
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
                            Icons.access_time,
                            size: 18.0,
                            color: Colors.teal,
                          ),
                          Text(
                            " $time",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
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
        )
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

  Future pickFromDateTime({@required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
  }

  Future<DateTime> pickDateTime(
    DateTime initialDate, {
    @required bool pickDate,
    DateTime firstDate,
  }) async {
    if (pickDate) {
      final DateTime date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2019, 8),
        lastDate: DateTime(2101),
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
