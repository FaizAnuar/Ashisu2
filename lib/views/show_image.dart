import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gowallpaper/bloc/theme.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:path/path.dart' as Path;
import 'package:gowallpaper/shared/constants.dart';

class ShowFileImage extends StatefulWidget {
  final File image;
  ShowFileImage({this.image});

  @override
  _ShowFileImageState createState() => _ShowFileImageState();
}

class _ShowFileImageState extends State<ShowFileImage> {
  File imageInShow = ShowFileImage().image;

  CollectionReference imgRef;
  fs.Reference ref;

  bool uploading = false;
  double val = 0;

  String _value = 'Others';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "Upload ",
                    style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontFamily: 'Bebas')),
                TextSpan(
                    text: "Photo",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 25, fontFamily: 'Bebas')),
              ]),
            ),
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                    child: Image(
                      height: 300,
                      width: 700,
                      image: FileImage(widget.image),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButton(
                      value: _value,
                      items: [
                        DropdownMenuItem(
                          child: Text("Cars"),
                          value: 'Cars',
                        ),
                        DropdownMenuItem(
                          child: Text("Bikes"),
                          value: 'Bikes',
                        ),
                        DropdownMenuItem(
                            child: Text("Aesthetic"), value: 'Aesthetic'),
                        DropdownMenuItem(
                            child: Text("Nature"), value: 'Nature'),
                        DropdownMenuItem(child: Text("City"), value: 'City'),
                        DropdownMenuItem(
                            child: Text("Others"), value: 'Others'),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.purple[400],
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 20),
                      RaisedButton(
                        color: Colors.purple[400],
                        child: Text(
                          'Upload',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            uploading = true;
                          });
                          uploadFile(_value)
                              .then((value) => Navigator.of(context).pop());
                        },
                      )
                    ],
                  ),
                ],
              ),
              uploading
                  ? Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [CircularProgressIndicator()],
                    ))
                  : Container(),
            ],
          )),
    );
  }

  Future uploadFile(String type) async {
    try {
      ref = fs.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(widget.image.path)}');

      await ref.putFile(widget.image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({
            'url': value,
            'location': 'images/${Path.basename(widget.image.path)}',
            'type': type
          });
        });

        showAlertDialog(
            context, "Photo Successfully Uploaded", 'Tap screen to close');
      });
    } catch (e) {
      showAlertDialog(
          context, "Failed to Upload. Please Try Again", 'Tap screen to close');
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
  }

  /*Future<void> _addPathToDatabase(String text) async {
    try {
      // Get image URL from firebase
      final ref1 = ref.child(text);
      var imageString = await ref1.getDownloadURL();

      // Add location and url to database

      await FirebaseFirestore.instance
          .collection('imageUrls')
          .doc()
          .set({'url': imageString, 'location': text});
    } catch (e) {
      print(e.message);
    }
  }*/
}
