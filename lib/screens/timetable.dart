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

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final usersRef = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = '';

  List<String> taskHeadingUrgent = [];
  List<String> taskDescUrgent = [];
  List<String> taskHeadingNotUrgent = [];
  List<String> taskDescNotUrgent = [];
  List<String> timeUrgent = [];
  List<String> timeNotUrgent = [];
  // List<String> selectionUrgent = [];
  // List<String> selectionNotUrgent = [];

  String filterType = "today";
  DateTime today = new DateTime.now();
  String taskPop = "close";

  @override
  void initState() {
    super.initState();
    User user = _auth.currentUser;
    uid = user.uid;
    getTaskArr(uid);
    print("list init");
    print(taskHeadingUrgent);
  }

  void getTaskArr(String uid) async {
    await usersRef.doc(uid).get().then((value) {
      //'value' is the instance of 'DocumentSnapshot'
      //'value.data()' contains all the data inside a document in the form of 'dictionary'
      var fields = value.data();

      //Using 'setState' to update the user's data inside the app
      //firstName, lastName and title are 'initialised variables'
      setState(
        () {
          if (fields['taskHeading'] != null) {
            int index = 0;
            for (int i = fields['taskHeading'].length; i > 0; i--) {
              if (fields['urgency'][index] == '0') {
                taskHeadingUrgent.add(fields['taskHeading'][index]);
                taskDescUrgent.add(fields['taskDescription'][index]);
                timeUrgent.add(fields['selectedTime'][index]);
                // selectionUrgent.add(fields['urgency'][index]);
              } else {
                taskHeadingNotUrgent.add(fields['taskHeading'][index]);
                taskDescNotUrgent.add(fields['taskDescription'][index]);
                timeNotUrgent.add(fields['selectedTime'][index]);
                // selectionUrgent.add(fields['urgency'][index]);
              }

              index++;
            }
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Task For Today",
              style: TextStyle(
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 24),
            ),
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
          ),
          body: buildPage('m'),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Urgent",
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ),
                        buildTaskUrgent(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Not Urgent",
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ),
                        buildTaskNotUrgent(),
                      ],
                    ),
                  ),
                  Container(
                    height: 110,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 65,
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

  Widget buildTaskUrgent() {
    final usersRef = FirebaseFirestore.instance.collection('Users');

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            left: 5,
            right: 5,
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: usersRef.doc(uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (taskHeadingUrgent.length != null) {
                  int lengthTask = taskHeadingUrgent.length;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lengthTask,
                    itemBuilder: (context, int index) {
                      return new Padding(
                        padding: const EdgeInsets.only(bottom: 5.5),
                        child: new Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          child: taskWidget(index, 0),
                        ),
                      );
                    },
                  );
                }
              }
              if (snapshot.hasError) {
                return Text("Something went wrong");
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
        ),
      ),
    );
  }

  Widget buildTaskNotUrgent() {
    final usersRef = FirebaseFirestore.instance.collection('Users');

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            left: 5,
            right: 5,
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: usersRef.doc(uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (taskHeadingNotUrgent.length != null) {
                  int lengthTask = taskHeadingNotUrgent.length;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lengthTask,
                    itemBuilder: (context, int index) {
                      return new Padding(
                        padding: const EdgeInsets.only(bottom: 5.5),
                        child: new Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          child: taskWidget(index, 1),
                        ),
                      );
                    },
                  );
                }
              }
              if (snapshot.hasError) {
                return Text("Something went wrong");
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
        ),
      ),
    );
  }

  Widget taskWidget(int index, int urgency) {
    final usersRef = FirebaseFirestore.instance.collection('Users');

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
      child: Container(
        height: 100,
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
                  border: Border.all(
                      color: taskMarginColor[
                          (index % taskMarginColor.length).floor()],
                      width: 4)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FutureBuilder<DocumentSnapshot>(
                      future: usersRef.doc(uid).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (urgency == 0) {
                            return Text(
                              taskHeadingUrgent[index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.00,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          } else {
                            return Text(
                              taskHeadingNotUrgent[index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.00,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
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
                      }),
                ),
                SizedBox(
                  height: 5,
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
                            if (urgency == 0) {
                              return AutoSizeText(
                                taskDescUrgent[index],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.00,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return AutoSizeText(
                                taskDescNotUrgent[index],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.00,
                                  color: Colors.black,
                                ),
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
                        }),
                  ),
                ),
                SizedBox(
                  height: 2,
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
                            if (urgency == 0) {
                              return AutoSizeText(
                                'Time :' + timeUrgent[index],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.00,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return AutoSizeText(
                                'Time :' + timeNotUrgent[index],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.00,
                                  color: Colors.black,
                                ),
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
                        }),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              height: 50,
              width: 5,
              color: taskColor[(index % taskColor.length).floor()],
            )
          ],
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          caption: "Done",
          color: taskColor[(index % taskColor.length).floor()],
          icon: Icons.fact_check,
          onTap: () {
            setState(() {
              if (urgency == 0) {
                int indexWhere1 = taskHeading.indexWhere(
                    (element) => element == taskHeadingUrgent[index]);
                int indexWhere2 = taskDescription
                    .indexWhere((element) => element == taskDescUrgent[index]);
                int indexWhere3 = taskTime
                    .indexWhere((element) => element == timeUrgent[index]);

                if (indexWhere1 == indexWhere2 && indexWhere2 == indexWhere3) {
                  taskHeading.removeAt(indexWhere1);
                  taskDescription.removeAt(indexWhere1);
                  taskTime.removeAt(indexWhere1);
                  selection.removeAt(indexWhere1);
                }

                taskHeadingUrgent.removeAt(index);
                taskDescUrgent.removeAt(index);
                timeUrgent.removeAt(index);
              } else {
                int indexWhere1 = taskHeading.indexWhere(
                    (element) => element == taskHeadingNotUrgent[index]);
                int indexWhere2 = taskDescription.indexWhere(
                    (element) => element == taskDescNotUrgent[index]);
                int indexWhere3 = taskTime
                    .indexWhere((element) => element == timeNotUrgent[index]);

                if (indexWhere1 == indexWhere2 && indexWhere2 == indexWhere3) {
                  taskHeading.removeAt(indexWhere1);
                  taskDescription.removeAt(indexWhere1);
                  taskTime.removeAt(indexWhere1);
                  selection.removeAt(indexWhere1);
                }

                taskHeadingNotUrgent.removeAt(index);
                taskDescNotUrgent.removeAt(index);
                timeNotUrgent.removeAt(index);
              }

              var firebaseUser = FirebaseAuth.instance.currentUser;
              firestoreInstance
                  .collection("Users")
                  .doc(firebaseUser.uid)
                  .update({
                "taskHeading": taskHeading,
                "taskDescription": taskDescription,
                "selectedTime": taskTime,
                "urgency": selection,
              }).then((_) {
                print("success!");
              });
            });
          },
        )
      ],
    );
  }
}
