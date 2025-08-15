import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static const String _collectionPath =
      'IAmNothing/NothingInsideMe/WhyAreYouFollowingThisCollection/here';
  static const String _fieldName = 'FlutterKillSwitch';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get The Current Kill Switch State From Firestore
  Future<bool> getKillSwitchState() async {
    try {
      final docRef = _firestore.doc(_collectionPath);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        return data?[_fieldName] ?? false;
      } else {
        // Document Doesn't Exist, Create It With Default Value False
        await docRef.set({_fieldName: false});
        return false;
      }
    } catch (e) {
      throw Exception('Failed To Get Kill Switch State: $e');
    }
  }

  /// Set The Kill Switch State In Firestore
  Future<void> setKillSwitchState(bool enabled) async {
    try {
      final docRef = _firestore.doc(_collectionPath);
      await docRef.set({
        _fieldName: enabled,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed To Set Kill Switch State: $e');
    }
  }

  /// Listen To Kill Switch State Changes
  Stream<bool> listenToKillSwitchState() {
    return _firestore.doc(_collectionPath).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return data?[_fieldName] ?? false;
      }
      return false;
    });
  }
}
