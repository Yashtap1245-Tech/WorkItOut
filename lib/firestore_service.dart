import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/workout.dart';
import '../model/exercise.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createGroupWorkout(
      String name, String type, List<Exercise> exercises) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String inviteCode = DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference workoutRef = _db.collection("group_workouts").doc();

    await workoutRef.set({
      "workoutName": name,
      "type": type,
      "createdBy": userId,
      "inviteCode": inviteCode,
      "participants": [userId],
    });

    for (var exercise in exercises) {
      await workoutRef.collection("exercises").doc(exercise.id.toString()).set({
        "name": exercise.name,
        "target": exercise.target,
        "unit": exercise.unit,
      });
    }

    return inviteCode;
  }

  Future<bool> joinGroupWorkout(String inviteCode) async {
    QuerySnapshot snapshot = await _db
        .collection("group_workouts")
        .where("inviteCode", isEqualTo: inviteCode)
        .get();

    if (snapshot.docs.isEmpty) return false;

    DocumentReference workoutRef = snapshot.docs.first.reference;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await workoutRef.update({
      "participants": FieldValue.arrayUnion([userId])
    });

    return true;
  }

  Future<void> submitWorkoutResult(
      String workoutId, String exerciseId, double output) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await _db
        .collection("group_workouts")
        .doc(workoutId)
        .collection("exercises")
        .doc(exerciseId)
        .collection("results")
        .doc(userId)
        .set({
      "output": output,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Stream<DocumentSnapshot> getGroupWorkout(String workoutId) {
    return _db.collection("group_workouts").doc(workoutId).snapshots();
  }
}
