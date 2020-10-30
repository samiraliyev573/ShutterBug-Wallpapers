import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperApp/services/artists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wallpaperApp/views/picturescreen.dart';
import 'package:wallpaperApp/widgets/loader.dart';

class ArtistProfilePage extends StatefulWidget {
  final String artistName;

  ArtistProfilePage(this.artistName);
  @override
  _ArtistProfilePageState createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {
  bool artistFlag = false;
  var artistPictures;
  List<DocumentSnapshot> pictureSnapshots;
  @override
  void initState() {
    super.initState();
    // ArtistService()
    //     .getLatestArtistPictures(widget.artistName)
    //     .then((QuerySnapshot docs) {
    //   if (docs.documents.isNotEmpty) {
    //     pictureSnapshots = docs.documents;
    //     print(pictureSnapshots.length);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Works of ${widget.artistName}'),
      ),
      body: Container(
        child: FutureBuilder(
          future: ArtistService()
              .getLatestArtistPictures(widget.artistName)
              .then((QuerySnapshot docs) {
            if (docs.documents.isNotEmpty) {
              pictureSnapshots = docs.documents;
              print(pictureSnapshots.length);
            }
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Text(
                    'Opps something went wrong. Please check your internet connection and come back later 😢');
              }
              try {
                return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: pictureSnapshots.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.5,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      String url = pictureSnapshots[index].data['url'];
                      String name = pictureSnapshots[index].data['artist'];
                      String hdurl = pictureSnapshots[index].data['hdurl'];
                      return Card(
                        elevation: 10,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return FullScreenImagePage(url, name, hdurl);
                            }));
                          },
                          child: CachedNetworkImage(
                            imageUrl: pictureSnapshots[index].data['url'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Loader(),
                          ),
                          // child: FadeInImage(
                          //   placeholder: AssetImage('assets/camerahighres.png'),
                          //   image: NetworkImage(
                          //     pictureSnapshots[index].data['url'],
                          //   ),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      );
                    });
              } catch (e) {
                return Center(
                    child: Text(
                  'Artist has not uploaded any pictures yet. Please come back later 😪',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ));
              }
            }
          },
        ),
      ),
    );
  }
}
