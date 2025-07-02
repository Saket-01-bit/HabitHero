import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/challenge_model.dart';


class FirestoreService {
  final CollectionReference _challengeRef =
  FirebaseFirestore.instance.collection('challenges');

  /// Returns only the current user's challenges
  Stream<List<Challenge>> getChallenges() {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _challengeRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Challenge.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Adds a challenge with the current user's userId
  Future<void> addChallenge(Challenge challenge) async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not logged in");

      final challengeWithUser = challenge.copyWith(userId: userId);
      await _challengeRef.add(challengeWithUser.toMap());
    } catch (e) {
      print('Error adding challenge: $e');
    }
  }

  Future<void> updateChallenge(Challenge challenge) async {
    await _challengeRef.doc(challenge.id).update(challenge.toMap());
  }

  Future<void> deleteChallenge(String id) async {
    await _challengeRef.doc(id).delete();
  }
}
