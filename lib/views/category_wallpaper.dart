import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gowallpaper/bloc/theme.dart';
import 'package:gowallpaper/views/image_view.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoriesView extends StatefulWidget {
  final String type;
  CategoriesView({Key key, this.type}) : super(key: key);
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> wallpapersList;

  final databaseReference = FirebaseFirestore.instance;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('imageURLs');

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    subscription = collectionReference
        .where('type', isEqualTo: widget.type.toString())
        .snapshots()
        .listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.docs;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      theme: theme.getTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(widget.type.toString(),
              style: TextStyle(
                  color: Colors.purple[400],
                  fontFamily: 'Bebas',
                  fontSize: 27)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.purple[400],
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 200,
              child: wallpapersList != null
                  ? StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.all(8.0),
                      crossAxisCount: 4,
                      itemCount: wallpapersList.length,
                      itemBuilder: (context, i) {
                        String imgPath = wallpapersList[i].get('url');
                        return Material(
                          elevation: 8.0,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageView(
                                    imgUrl: imgPath,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: imgPath,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FadeInImage.memoryNetwork(
                                  image: imgPath,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (i) =>
                          new StaggeredTile.count(2, i.isEven ? 2 : 3),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ]),
      ),
    );
  }
}
