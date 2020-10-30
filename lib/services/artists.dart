import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistService {
  getLatestArtistPictures(String artistName) {
    return Firestore.instance
        .collection('wallpapers')
        .where('artist', isEqualTo: artistName)
        .getDocuments();
  }
}
