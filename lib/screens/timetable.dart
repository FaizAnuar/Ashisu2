import 'package:Ashisu/models/timetablePage.dart';
import 'package:Ashisu/screens/select.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:flutter/material.dart';
import 'CheckList.dart';
import 'NewTask.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TimetablePage extends StatelessWidget {
  static ValueNotifier<String> taskValue = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'avenir'),
      home: timetablePage(),
    );
  }
}

class timetablePage extends StatefulWidget {
  @override
  _timetablePageState createState() => _timetablePageState();
}

class _timetablePageState extends State<timetablePage> {
  static ValueNotifier<String> taskValue = ValueNotifier('');

  String filterType = "today";
  DateTime today = new DateTime.now();
  String taskPop = "close";
  var monthNames = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEPT",
    "OCT",
    "NOV",
    "DEC"
  ];
  CalendarController ctrlr = new CalendarController();

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Timetable"),
            //centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SelectPage()));
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            ],
            //backgroundColor: Colors.purple,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.red],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: [
                Tab(text: 'Mon'),
                Tab(text: 'Tue'),
                Tab(text: 'Wed'),
                Tab(text: 'Thu'),
                Tab(text: 'Fri'),
                Tab(text: 'Sat'),
                Tab(text: 'Sun'),
              ],
            ),
            elevation: 20,
            titleSpacing: 20,
          ),
          body: TabBarView(
            children: [
              buildPage('Monday'),
              buildPage1('t'),
              buildPage('w'),
              buildPage('t'),
              buildPage('f'),
              buildPage('s'),
              buildPage('sun'),
            ],
          ),
        ),
      );

  Widget buildPage(String text) => Center(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today ${monthNames[today.month - 1]}, ${today.day}/${today.year}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: taskValue,
                            builder: (BuildContext context, String newValue,
                                Widget child) {
                              return Text(
                                newValue,
                                style: TextStyle(fontSize: 18),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 110,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xff292e4e),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 80,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          left: 0,
                          right: 0,
                          child: InkWell(
                            onTap: openTaskPop,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Color(0xfff96060), Colors.red],
                                  ),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                child: (taskPop == "open")
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: InkWell(
                            onTap: closeTaskPop,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white),
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 1,
                                  ),
                                  InkWell(
                                    onTap: openNewTask,
                                    child: Container(
                                      child: Text(
                                        "Add Task",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  InkWell(
                                    onTap: openNewCheckList,
                                    child: Container(
                                      child: Text(
                                        "Add Reminder",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              )
            ],
          ),
        ),
      );

  Widget buildPage1(String text) => Center(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today ${monthNames[today.month - 1]}, ${today.day}/${today.year}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          taskWidget(Color(0xfff96060), "Meeting with love",
                              "9:00 AM"),
                          taskWidget(
                              Colors.blue, "Meeting with someone", "9:00 AM"),
                          taskWidget(
                              Colors.green, "Take your medicines", "9:00 AM"),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 110,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xff292e4e),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 80,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          left: 0,
                          right: 0,
                          child: InkWell(
                            onTap: openTaskPop,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Color(0xfff96060), Colors.red],
                                  ),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                child: (taskPop == "open")
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: InkWell(
                            onTap: closeTaskPop,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white),
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 1,
                                  ),
                                  InkWell(
                                    onTap: openNewTask,
                                    child: Container(
                                      child: Text(
                                        "Add Task",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  InkWell(
                                    onTap: openNewCheckList,
                                    child: Container(
                                      child: Text(
                                        "Add Reminder",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              )
            ],
          ),
        ),
      );

  openNewTask() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewTask()));
  }

  openNewCheckList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CheckList()));
  }

  openTaskPop() {
    taskPop = "open";
    setState(() {});
  }

  closeTaskPop() {
    taskPop = "close";
    setState(() {});
  }

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }
}

Slidable taskWidget(Color color, String title, String time) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.3,
    child: Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: Offset(0, 9),
              blurRadius: 20,
              spreadRadius: 1)
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 4)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              )
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            height: 50,
            width: 5,
            color: color,
          )
        ],
      ),
    ),
    secondaryActions: [
      IconSlideAction(
        caption: "Edit",
        color: Colors.white,
        icon: Icons.edit,
        onTap: () {},
      ),
      IconSlideAction(
        caption: "Delete",
        color: color,
        icon: Icons.edit,
        onTap: () {},
      )
    ],
  );
}
