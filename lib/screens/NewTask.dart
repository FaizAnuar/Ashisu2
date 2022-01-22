import 'package:Ashisu/models/timetablePage.dart';
import 'package:Ashisu/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ink_widget/ink_widget.dart';
import 'timetable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'avenir'),
      home: newTask(),
    );
  }
}

class newTask extends StatefulWidget {
  newTask({Key key}) : super(key: key);

  @override
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<newTask> {
  String select;
  List<bool> isSelected;
  List<String> timeList;
  var _formKey = GlobalKey<FormState>();
  String Day;
  TimeOfDay selectedTime = TimeOfDay.now();
  final usersRef = FirebaseFirestore.instance.collection('Users');

  var index;

  @override
  void initState() {
    super.initState();
    isSelected = [true, false];
    taskDescriptionMaxLength =
        taskDescriptionMaxLines * taskDescriptionMaxLines;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xfff96060),
        elevation: 0,
        title: Text(
          "New Task",
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TimetablePage()));
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Color(0xfff96060),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLength: taskHeaderMaxLength,
                      controller: taskHeadingController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        fillColor: Colors.blue,
                        hintText: "Title",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(
                            width: 5.0,
                          ),
                        ),
                      ),
                      validator: (String taskHeading) {
                        if (taskHeading.isEmpty) {
                          return "Please enter task Heading";
                        } else if (taskHeading.startsWith(" ")) {
                          return "Please avoid whitespaces";
                        }
                        return null;
                      },
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context)
                            .requestFocus(textSecondFocusNode);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15)),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            child: TextFormField(
                              focusNode: textSecondFocusNode,
                              maxLines: taskDescriptionMaxLines,
                              maxLength: taskDescriptionMaxLength,
                              controller: taskDescriptionController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add description here",
                              ),
                              style: TextStyle(fontSize: 18),
                              validator: (String taskDescription) {
                                if (taskDescription.isEmpty) {
                                  return "Please enter Note Desc";
                                } else {
                                  if (taskDescription.startsWith(" ")) {
                                    return "Please avoid whitespaces";
                                  }
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.attach_file,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {},
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Urgency :",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ToggleButtons(
                            borderColor: Colors.black,
                            fillColor: Colors.grey,
                            borderWidth: 2,
                            selectedBorderColor: Colors.black,
                            selectedColor: Colors.white,
                            borderRadius: BorderRadius.circular(0),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Urgent',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Not Urgent',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                                select = index.toString();
                              });
                            },
                            isSelected: isSelected,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            elevation: 4.0,
                            onPressed: () => _selectTime(context),
                            child: Container(
                              alignment: Alignment.center,
                              height: 75.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.access_alarms_rounded,
                                              size: 18.0,
                                              color: Colors.teal,
                                            ),
                                            Text(
                                              "${selectedTime.hour}:${selectedTime.minute}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.purple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
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
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  taskHeading.add(taskHeadingController.text);
                                  print(taskHeadingController.text);
                                  taskDescription
                                      .add(taskDescriptionController.text);
                                  taskTime.add(
                                      ("${selectedTime.hour}:${selectedTime.minute}")
                                          .toString());
                                  selection.add(select);
                                  selectionController.clear();
                                  taskHeadingController.clear();
                                  taskDescriptionController.clear();

                                  var firebaseUser =
                                      FirebaseAuth.instance.currentUser;
                                  firestoreInstance
                                      .collection("Users")
                                      .doc(firebaseUser.uid)
                                      .set({
                                    "urgency": selection,
                                    "taskHeading": taskHeading,
                                    "taskDescription": taskDescription,
                                    "selectedTime": taskTime,
                                  }, SetOptions(merge: true)).then((_) {
                                    print("success!");
                                  });
                                });
                              }

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TimetablePage()));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xffff96060)),
                              child: Center(
                                child: Text(
                                  "Add Task",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
