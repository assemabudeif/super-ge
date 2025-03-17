import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final db = FirebaseFirestore.instance;
  static final collectionsCollection = db.collection('collections');
  static CollectionReference<Map<String, dynamic>> entriesCollection(
          String collectionId) =>
      db.collection('collections').doc(collectionId).collection('entries');
  static final usersCollection = db.collection('users');
}
