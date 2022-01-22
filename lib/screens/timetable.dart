import 'package:Ashisu/models/timetablePage.dart';
import 'package:Ashisu/screens/select.dart';
import 'package:Ashisu/services/database.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'NewTask.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'NewTask.dart';

class TimetablePage extends StatelessWidget {
  final usersRef = FirebaseFirestore.instance.collection('Users');

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
  timetablePage({Key key, String taskDescription, String taskHeading})
      : super(key: key);

  @override
  _timetablePageState createState() => _timetablePageState();
}

class _timetablePageState extends State<timetablePage> {
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
              buildPage('m'),
              buildPage('t'),
              buildPage('w'),
              buildPage('t'),
              buildPage('f'),
              buildPage('s'),
              buildPage('s'),
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
                children: <Widget>[
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
                                  "Urgent",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                )
                              ],
                            ),
                          ),
                          buildTask(),
                        ],
                      ),
                    ),
                  ),
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
                                  "Not Urgent",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green),
                                )
                              ],
                            ),
                          ),
                          taskWidget(Color(0xfff96060), "Meeting with someone",
                              "9:00 AM"),
                          taskWidget(
                              Colors.blue, "Meeting with someone", "9:00 AM"),
                          taskWidget(
                              Colors.green, "Take your medicines", "9:00 AM"),
                          buildTask(),
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
                            onTap: openNewTask,
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
            ],
          ),
        ),
      );

  openNewTask() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewTask()));
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

  Widget buildTask() {
    int lengthTask;
    final usersRef = FirebaseFirestore.instance.collection('Users');

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.data != null) {
            return Container(
              child: Text(""),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            lengthTask = data['taskDescription'].length;
            print("this is the task length " + lengthTask.toString());

            if (data['taskDescription'].length > 0) {
              return ListView.builder(
                itemCount: lengthTask,
                itemBuilder: (context, int index) {
                  return new Padding(
                    padding: const EdgeInsets.only(bottom: 5.5),
                    child: new Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        setState(() {
                          deletedTaskHeading = taskHeading[index];
                          deletedTaskDescription = taskDescription[index];
                          taskHeading.removeAt(index);
                          taskDescription.removeAt(index);
                          Scaffold.of(context).showSnackBar(
                            new SnackBar(
                              backgroundColor: Colors.purple,
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new Text(
                                    "Note Deleted",
                                    style: TextStyle(),
                                  ),
                                  deletedTaskHeading != ""
                                      ? GestureDetector(
                                          onTap: () {
                                            print("undo");
                                            setState(() {
                                              if (deletedTaskHeading != "") {
                                                taskHeading
                                                    .add(deletedTaskHeading);
                                                taskDescription.add(
                                                    deletedTaskDescription);
                                              }
                                              deletedTaskHeading = "";
                                              deletedTaskDescription = "";
                                            });
                                            var firebaseUser = FirebaseAuth
                                                .instance.currentUser;
                                            firestoreInstance
                                                .collection("users")
                                                .doc(firebaseUser.uid)
                                                .update({
                                              "noteHeading":
                                                  FieldValue.delete(),
                                              "noteDescription":
                                                  FieldValue.delete(),
                                            }).then((_) {
                                              print("success!");
                                            });
                                          },
                                          child: new Text(
                                            "Undo",
                                            style: TextStyle(),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                      background: ClipRRect(
                        borderRadius: BorderRadius.circular(5.5),
                        child: Container(
                          color: Colors.green,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      secondaryBackground: ClipRRect(
                        borderRadius: BorderRadius.circular(5.5),
                        child: Container(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: TaskList(index),
                    ),
                  );
                },
              );
            }
          }
          return Container(
            color: Colors.transparent,
            child: Center(
              child: SpinKitChasingDots(
                color: Color(0xffFFD119),
                size: 50,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget TaskList(int index) {
    final usersRef = FirebaseFirestore.instance.collection('Users');

    print("this is index in Tasklist " + index.toString());
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: taskColor[(index % taskColor.length).floor()],
          borderRadius: BorderRadius.circular(5.5),
        ),
        height: 100,
        child: Center(
          child: Row(
            children: [
              new Container(
                color:
                    taskMarginColor[(index % taskMarginColor.length).floor()],
                width: 3.5,
                height: double.infinity,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: FutureBuilder<DocumentSnapshot>(
                            future: usersRef.doc(uid).get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> data =
                                    snapshot.data.data();
                                return Text(
                                  data['taskHeading'][index].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20.00,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }
                              return Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: SpinKitChasingDots(
                                    color: Color(0xffFFD119),
                                    size: 50,
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 2.5,
                      ),
                      Flexible(
                        child: Container(
                          height: double.infinity,
                          child: FutureBuilder<DocumentSnapshot>(
                              future: usersRef.doc(uid).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data =
                                      snapshot.data.data();
                                  return AutoSizeText(
                                    data['taskDescription'][index].toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15.00,
                                      color: Colors.black,
                                    ),
                                  );
                                }
                                return Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: SpinKitChasingDots(
                                      color: Color(0xffFFD119),
                                      size: 50,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: double.infinity,
                          child: FutureBuilder<DocumentSnapshot>(
                              future: usersRef.doc(uid).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data =
                                      snapshot.data.data();
                                  return AutoSizeText(
                                    data['selectedTime'][index].toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15.00,
                                      color: Colors.black,
                                    ),
                                  );
                                }
                                return Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: SpinKitChasingDots(
                                      color: Color(0xffFFD119),
                                      size: 50,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
