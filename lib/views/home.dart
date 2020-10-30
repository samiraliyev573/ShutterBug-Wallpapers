import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:wallpaperApp/views/picturescreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaperApp/widgets/loader.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DocumentSnapshot> wallpapersList;
  StreamSubscription<QuerySnapshot> subscription;
  final CollectionReference collectionReference =
      Firestore.instance.collection('wallpapers');

  @override
  void initState() {
    super.initState();

    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            wallpapersList != null
                ? Expanded(
                    child: StaggeredGridView.countBuilder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8.0),
                      crossAxisCount: 4,
                      itemCount: wallpapersList.length,
                      itemBuilder: (context, index) {
                        String imgPath = wallpapersList[index].data['url'];
                        String artistName =
                            wallpapersList[index].data['artist'];
                        String hdimagePath =
                            wallpapersList[index].data['hdurl'];
                        return Material(
                          elevation: 8.0,
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FullScreenImagePage(
                                    imgPath, artistName, hdimagePath);
                              }));
                            },
                            child: Hero(
                                tag: imgPath,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(
                                      imageUrl: imgPath,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Loader()),
                                )),
                          ),
                        );
                      },
                      staggeredTileBuilder: (i) =>
                          StaggeredTile.count(2, i.isEven ? 2 : 3),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )
          ],
        ),
      ),
    );
  }
}
