import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController ctrl = PageController(viewportFraction: 0.6);
  final Firestore db = Firestore.instance;
  Stream slides;

  String activeTag = 'favourite';

  //keep track of the current page to avoid unnecessary renders
  int currentpage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _queryDB();
    ctrl.addListener(() {
      int next = ctrl.page.round();
      if (currentpage != next) {
        setState(() {
          currentpage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 400,
            child: StreamBuilder(
                stream: slides,
                initialData: [],
                builder: (context, AsyncSnapshot snap) {
                  List slideList = snap.data.toList();

                  return PageView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: ctrl,
                    itemCount: slideList.length + 1,
                    itemBuilder: (context, int currentIndex) {
                      if (currentIndex == 0) {
                        return _buildTagPage();
                      } else if (slideList.length >= currentIndex) {
                        //Active Page
                        bool active = currentIndex == currentpage;
                        return _buildStoryPage(
                            slideList[currentIndex - 1], active);
                      }
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Stream _queryDB({String tag = 'favourite'}) {
    //Make a query
    Query query = db.collection('wallpapers').where('tags', isEqualTo: tag);

    // Map the documents to the data payload
    slides = query.snapshots().map((list) => list.documents.map((e) => e.data));
    // Update the active tag
    setState(() {
      activeTag = tag;
    });
  }
}

//builder functions

_buildStoryPage(Map data, bool active) {
  final double blur = active ? 30 : 0;
  final double offset = active ? 20 : 0;
  final double top = active ? 100 : 200;

  return AnimatedContainer(
    width: 200,
    height: 500,
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            data['url'],
          ),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black87,
              blurRadius: blur,
              offset: Offset(offset, offset))
        ]),
    child: Center(
      child: Text(
        data['artist'],
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
  );
}

Widget _buildTagPage() {
  return Container();
}
