import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  getLatestCategoryPictures(String categoryName) {
    return Firestore.instance
        .collection('wallpapers')
        .where('category', isEqualTo: categoryName)
        .getDocuments();
  }
}
