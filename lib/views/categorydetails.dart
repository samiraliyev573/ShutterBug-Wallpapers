import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperApp/data/data.dart';
import 'package:wallpaperApp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaperApp/services/categories.dart';
import 'package:wallpaperApp/views/picturescreen.dart';
import 'package:wallpaperApp/widgets/loader.dart';

class CategoryDetails extends StatefulWidget {
  final String categoryName;
  final CategoryInfo planetInfo;

  CategoryDetails({this.planetInfo, this.categoryName});

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  List<DocumentSnapshot> categorySnapshots;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 200),
                        Text(
                          widget.planetInfo.name,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 56,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Divider(color: Colors.black38),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                  Container(
                    height: 350,
                    padding: const EdgeInsets.only(left: 32.0),
                    child: FutureBuilder(
                      future: CategoryService()
                          .getLatestCategoryPictures(widget.categoryName)
                          .then((QuerySnapshot docs) {
                        if (docs.documents.isNotEmpty) {
                          categorySnapshots = docs.documents;
                          print(categorySnapshots.length);
                        }
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Text('Loading...'),
                          );
                        } else {
                          if (snapshot.hasError) {
                            return Text(
                                'Opps something went wrong. Please check your connection and come back later 😢');
                          }
                          try {
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: categorySnapshots.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                String url =
                                    categorySnapshots[index].data['url'];
                                String name =
                                    categorySnapshots[index].data['artist'];
                                String hdurl =
                                    categorySnapshots[index].data['hdurl'];
                                return Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: AspectRatio(
                                      aspectRatio: 0.6,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return FullScreenImagePage(
                                                url, name, hdurl);
                                          }));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: categorySnapshots[index]
                                              .data['url'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Loader(),
                                        ),
                                        // child: FadeInImage(
                                        //   placeholder: AssetImage(
                                        //       'assets/camerahighres.png'),
                                        //   image: NetworkImage(
                                        //     categorySnapshots[index]
                                        //         .data['url'],
                                        //   ),
                                        //   fit: BoxFit.cover,
                                        // ),
                                      )),
                                );
                              },
                            );
                          } catch (e) {
                            return Center(
                                child: Text(
                              'There are no images for this category. Please come back later 😪',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ));
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(widget.planetInfo.iconImage)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 32,
              child: Text(
                widget.planetInfo.position.toString(),
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 200,
                  color: primaryTextColor.withOpacity(0.08),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
