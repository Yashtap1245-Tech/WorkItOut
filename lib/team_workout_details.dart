import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamWorkoutDetails extends StatefulWidget {
  final String workoutId;
  final String workoutType;

  const TeamWorkoutDetails({super.key, required this.workoutId, required this.workoutType});

  @override
  _TeamWorkoutDetailsState createState() => _TeamWorkoutDetailsState();
}

class _TeamWorkoutDetailsState extends State<TeamWorkoutDetails> {
  bool _loading = true;
  List<Map<String, dynamic>> exercises = [];
  Map<String, double> totalResults = {};
  Map<String, double> userOutputs = {};
  Map<String, int> userRanks = {};

  @override
  void initState() {
    super.initState();
    _fetchWorkoutDetails();
  }

  Future<void> _fetchWorkoutDetails() async {
    DocumentSnapshot workoutSnapshot = await FirebaseFirestore.instance
        .collection("group_workouts")
        .doc(widget.workoutId)
        .get();

    if (!workoutSnapshot.exists) return;

    QuerySnapshot exerciseSnapshot = await FirebaseFirestore.instance
        .collection("group_workouts")
        .doc(widget.workoutId)
        .collection("exercises")
        .get();

    exercises = exerciseSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return {
        "id": doc.id,
        "name": data["name"],
        "target": data["target"],
        "unit": data["unit"],
      };
    }).toList();

    for (var exercise in exercises) {
      totalResults[exercise["id"]] = 0.0;
      userOutputs[exercise["id"]] = 0.0;
      userRanks[exercise["id"]] = 0;
    }

    _fetchResults();
  }

  Future<void> _fetchResults() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    for (var exercise in exercises) {
      QuerySnapshot resultSnapshot = await FirebaseFirestore.instance
          .collection("group_workouts")
          .doc(widget.workoutId)
          .collection("exercises")
          .doc(exercise["id"])
          .collection("results")
          .get();

      double total = 0.0;
      List<Map<String, dynamic>> userScores = [];
      double userOutput = 0.0;

      for (var doc in resultSnapshot.docs) {
        String userId = doc.id;
        double output = (doc["output"] as num).toDouble();
        total += output;
        if (userId == currentUserId) {
          userOutput = output;
        }
        userScores.add({"userId": userId, "output": output});
      }

      totalResults[exercise["id"]] = total;
      userOutputs[exercise["id"]] = userOutput;
      userScores.sort((a, b) => b["output"].compareTo(a["output"]));
      userRanks[exercise["id"]] = userScores.indexWhere((e) => e["userId"] == currentUserId) + 1;
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Team Workout Details")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...exercises.map((exercise) {
              bool success = widget.workoutType == "collaborative"
                  ? totalResults[exercise["id"]]! >= exercise["target"]
                  : userOutputs[exercise["id"]]! >= exercise["target"];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(exercise["name"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Target: ${exercise["target"]} ${exercise["unit"]}"),
                      if (widget.workoutType == "collaborative")
                        Text("Total Team Output: ${totalResults[exercise["id"]]} ${exercise["unit"]}"),
                      if (widget.workoutType == "competitive")
                        Text("Your Rank: ${userRanks[exercise["id"]]}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(
                        success ? Icons.check_circle : Icons.cancel,
                        color: success ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}