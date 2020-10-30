import 'dart:async';

import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaperApp/views/artistProfilepage.dart';
import 'package:wallpaperApp/widgets/custom_card.dart';
import 'dart:math';

class ExploreArtists extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ExploreArtists> {
  List<PreloadPageController> controllers = [];
  List<DocumentSnapshot> artistList;
  StreamSubscription<QuerySnapshot> subscription;
  final CollectionReference collectionReference =
      Firestore.instance.collection('artists');

  //final firestoreReference = Firestore.instance;

  void getData() {
    // firestoreReference
    //     .collection("artists")
    //     .getDocuments()
    //     .then((QuerySnapshot snapshot) {
    //   snapshot.documents.forEach((f) => print('${f.data}}'));
    // });
  }

  @override
  void initState() {
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        artistList = datasnapshot.documents;
      });
    });
    var random = Random().nextInt(5);
    controllers = [
      PreloadPageController(viewportFraction: 0.6, initialPage: random),
      PreloadPageController(viewportFraction: 0.6, initialPage: random),
      PreloadPageController(viewportFraction: 0.6, initialPage: random),
      PreloadPageController(viewportFraction: 0.6, initialPage: random),
      PreloadPageController(viewportFraction: 0.6, initialPage: random),
    ];
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();

    super.dispose();
  }

  _animatePage(int page, int index) {
    for (int i = 0; i < 5; i++) {
      if (i != index) {
        controllers[i].animateToPage(page,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var random = Random().nextInt(4);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Stack(children: <Widget>[
            PreloadPageView.builder(
              controller: PreloadPageController(
                  viewportFraction: 0.7, initialPage: random),
              itemCount: 4,
              preloadPagesCount: 5,
              itemBuilder: (context, mainIndex) {
                return PreloadPageView.builder(
                  itemCount: 5,
                  preloadPagesCount: 5,
                  controller: controllers[mainIndex],
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  onPageChanged: (page) {
                    _animatePage(page, mainIndex);
                  },
                  itemBuilder: (context, index) {
                    var hitIndex = (mainIndex * 5) + index;
                    var img;
                    var name;
                    var insta;
                    String imgPath = artistList[index].data['profileurl'];
                    // String artistName = artistList[index].data['name'];
                    // String instaName = artistList[index].data['igname'];
                    if (imgPath != null) {
                      img = artistList[hitIndex].data['profileurl'];
                      name = artistList[hitIndex].data['name'];
                      insta = artistList[hitIndex].data['igname'];
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ArtistProfilePage(name);
                        }));
                      },
                      child: CustomCard(
                        title: name,
                        url: img,
                        instaname: insta,
                      ),
                    );
                  },
                );
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: IconButton(
                      color: Colors.black,
                      iconSize: 40,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      }),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
