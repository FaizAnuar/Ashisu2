import 'package:flutter/material.dart';
import 'package:Ashisu/screens/event_editing_page.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 1,
        centerTitle: true,
        title: Text("Calendar",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.amber[200]),
            textAlign: TextAlign.center),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventEditingPage()),
          );
        },
      ),
      body: Container(
        child: SfCalendar(
          view: CalendarView.month,
          cellBorderColor: Colors.transparent,
        ),
      ),
    );
  }
}
