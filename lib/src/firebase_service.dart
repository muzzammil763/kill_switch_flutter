import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static const String _collectionPath =
      'IAmNothing/NothingInsideMe/WhyAreYouFollowingThisCollection/here';
  static const String _fieldName = 'FlutterKillSwitch';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get the current kill switch state from Firestore
  Future<bool> getKillSwitchState() async {
    try {
      final docRef = _firestore.doc(_collectionPath);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        return data?[_fieldName] ?? false;
      } else {
        // Document doesn't exist, create it with default value false
        await docRef.set({_fieldName: false});
        return false;
      }
    } catch (e) {
      throw Exception('Failed to get kill switch state: $e');
    }
  }

  /// Set the kill switch state in Firestore
  Future<void> setKillSwitchState(bool enabled) async {
    try {
      final docRef = _firestore.doc(_collectionPath);
      await docRef.set({
        _fieldName: enabled,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to set kill switch state: $e');
    }
  }

  /// Listen to kill switch state changes
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
