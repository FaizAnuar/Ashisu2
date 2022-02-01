import 'package:Ashisu/models/event.dart';
import 'package:Ashisu/screens/select.dart';
import 'package:Ashisu/services/database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Ashisu/screens/event_editing_page.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final usersRef = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int firebaseArrayLength;
  @override
  void initState() {
    super.initState();
    User user = _auth.currentUser;
    uid = user.uid;
    getFirebaseReminderLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calendar",
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SelectPage()));
          },
        ),
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
                      child: SfCalendar(
                        view: CalendarView.month,
                        cellBorderColor: Colors.grey[400],
                      ),
                    ),
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
                        "Reminder",
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                    buildTask(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTask() {
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
                if (reminderHeading.length != null) {
                  int lengthTask = reminderHeading.length;
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
                          return Text(
                            reminderHeading[index],
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
                            return AutoSizeText(
                              'Date:' + reminderDate[index],
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
                            return AutoSizeText(
                              'Time :' + reminderTime[index],
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
            Expanded(
              child: Container(),
            ),
            Container(
              height: 50,
              width: 5,
              color: ReminderColor[(index % ReminderColor.length).floor()],
            )
          ],
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          caption: "Delete",
          color: ReminderColor[(index % ReminderColor.length).floor()],
          icon: Icons.delete,
          onTap: () {
            setState(() {
              reminderHeading.removeAt(index);
              reminderTime.removeAt(index);
              reminderDate.removeAt(index);

              var firebaseUser = FirebaseAuth.instance.currentUser;
              firestoreInstance
                  .collection("Users")
                  .doc(firebaseUser.uid)
                  .update({
                "reminderHeading": reminderHeading,
                "selectedReminderTime": reminderTime,
                "reminderDate": reminderDate,
              }).then((_) {
                print("success!");
              });
            });
          },
        )
      ],
    );
  }

  void getFirebaseReminderLength() {
    usersRef.doc(uid).get().then((value) {
      //'value' is the instance of 'DocumentSnapshot'
      //'value.data()' contains all the data inside a document in the form of 'dictionary'
      var fields = value.data();

      //Using 'setState' to update the user's data inside the app
      //firstName, lastName and title are 'initialised variables'
      setState(() {
        firebaseArrayLength = fields['reminderHeading'].length;
      });
    });
  }
}
