import 'package:Ashisu/screens/select.dart';
import 'package:Ashisu/services/database.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:Ashisu/models/NotesPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NotesWidget extends StatefulWidget {
  NotesWidget({Key key}) : super(key: key);

  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  var _formKey = GlobalKey<FormState>();
  String notes;
  final usersRef = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
    notesDescriptionMaxLenth =
        notesDescriptionMaxLines * notesDescriptionMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        //centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
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
      body: buildNotes(),
      floatingActionButton: FloatingActionButton(
        mini: false,
        backgroundColor: Colors.purple,
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: Icon(Icons.create),
      ),
    );
  }

  Widget buildNotes() {
    int lengthNotes;

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
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            lengthNotes = data['noteDescription'].length;
            print("this is the notes length " + lengthNotes.toString());

            if (data['noteDescription'].length > 0) {
              return ListView.builder(
                itemCount: lengthNotes,
                itemBuilder: (context, int index) {
                  return new Padding(
                    padding: const EdgeInsets.only(bottom: 5.5),
                    child: new Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        setState(() {
                          deletedNoteHeading = noteHeading[index];
                          deletedNoteDescription = noteDescription[index];
                          noteHeading.removeAt(index);
                          noteDescription.removeAt(index);
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
                                  deletedNoteHeading != ""
                                      ? GestureDetector(
                                          onTap: () {
                                            print("undo");
                                            setState(() {
                                              if (deletedNoteHeading != "") {
                                                noteHeading
                                                    .add(deletedNoteHeading);
                                                noteDescription.add(
                                                    deletedNoteDescription);
                                              }
                                              deletedNoteHeading = "";
                                              deletedNoteDescription = "";
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
                      child: noteList(index),
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

  Widget noteList(int index) {
    print("this is index in notelist " + index.toString());
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: noteColor[(index % noteColor.length).floor()],
          borderRadius: BorderRadius.circular(5.5),
        ),
        height: 100,
        child: Center(
          child: Row(
            children: [
              new Container(
                color:
                    noteMarginColor[(index % noteMarginColor.length).floor()],
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
                                  data['noteHeading'][index].toString(),
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
                                    data['noteDescription'][index].toString(),
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 50,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (MediaQuery.of(context).size.height),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 250, top: 50),
                  child: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Note",
                            style: TextStyle(
                              fontSize: 20.00,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  noteHeading.add(noteHeadingController.text);
                                  noteDescription
                                      .add(noteDescriptionController.text);
                                  noteHeadingController.clear();
                                  noteDescriptionController.clear();
                                });
                                var firebaseUser =
                                    FirebaseAuth.instance.currentUser;
                                firestoreInstance
                                    .collection("Users")
                                    .doc(firebaseUser.uid)
                                    .set({
                                  "noteHeading": noteHeading,
                                  "noteDescription": noteDescription,
                                }, SetOptions(merge: true)).then((_) {
                                  print("success!");
                                });
                              }
                              print("Notes.dart LineNo:239");
                              print(noteHeadingController.text);
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 20.00,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.blueAccent,
                        thickness: 2.5,
                      ),
                      TextFormField(
                        maxLength: notesHeaderMaxLenth,
                        controller: noteHeadingController,
                        decoration: InputDecoration(
                          hintText: "Note Heading",
                          hintStyle: TextStyle(
                            fontSize: 15.00,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        // ignore: missing_return
                        validator: (String noteHeading) {
                          if (noteHeading.isEmpty) {
                            return "Please enter Note Heading";
                          } else if (noteHeading.startsWith(" ")) {
                            return "Please avoid whitespaces";
                          }
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context)
                              .requestFocus(textSecondFocusNode);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          margin: EdgeInsets.all(1),
                          height: 5 * 24.0,
                          child: TextFormField(
                            focusNode: textSecondFocusNode,
                            maxLines: notesDescriptionMaxLines,
                            maxLength: notesDescriptionMaxLenth,
                            controller: noteDescriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                fontSize: 15.00,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // ignore: missing_return
                            validator: (String noteDescription) {
                              if (noteDescription.isEmpty) {
                                return "Please enter Note Desc";
                              } else {
                                if (noteDescription.startsWith(" ")) {
                                  return "Please avoid whitespaces";
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
