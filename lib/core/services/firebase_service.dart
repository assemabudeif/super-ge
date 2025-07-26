import 'package:cloud_firestore/cloud_firestore.dart';

/// A service class to provide easy access to Firebase Firestore collections.
///
/// This class contains static references to the main collections used in the application,
/// simplifying database interactions throughout the codebase.
class FirebaseService {
  /// The main instance of [FirebaseFirestore].
  static final db = FirebaseFirestore.instance;

  /// A reference to the top-level 'collections' collection.
  static final collectionsCollection = db.collection('collections');

  /// Returns a reference to the 'entries' subcollection for a specific collection document.
  ///
  /// [collectionId] The ID of the parent collection document.
  static CollectionReference<Map<String, dynamic>> entriesCollection(
          String collectionId) =>
      db.collection('collections').doc(collectionId).collection('entries');

  /// A reference to the top-level 'users' collection.
  static final usersCollection = db.collection('users');

  /// A reference to the top-level 'notes' collection.
  static final notesCollection = db.collection('notes');

  /// A reference to the top-level 'bills' collection.
  static final billsCollection = db.collection('bills');
}
