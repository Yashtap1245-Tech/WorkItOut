import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupWorkoutRecordingPage extends StatefulWidget {
  final String workoutId;

  const GroupWorkoutRecordingPage({super.key, required this.workoutId});

  @override
  _GroupWorkoutRecordingPageState createState() => _GroupWorkoutRecordingPageState();
}

class _GroupWorkoutRecordingPageState extends State<GroupWorkoutRecordingPage> {
  final Map<String, TextEditingController> _controllers = {};
  bool _loading = true;
  String workoutType = "collaborative"; // Default type
  List<Map<String, dynamic>> exercises = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutDetails();
  }

  Future<void> _loadWorkoutDetails() async {
    // Fetch workout details
    DocumentSnapshot workoutSnapshot = await FirebaseFirestore.instance
        .collection("group_workouts")
        .doc(widget.workoutId)
        .get();

    if (workoutSnapshot.exists) {
      var data = workoutSnapshot.data() as Map<String, dynamic>;
      workoutType = data["type"];
    }

    // Fetch exercises for this workout
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
      _controllers[exercise["id"]] = TextEditingController();
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _submitWorkoutResults() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    for (var exercise in exercises) {
      String exerciseId = exercise["id"];
      double output = double.tryParse(_controllers[exerciseId]?.text ?? "0") ?? 0.0;

      await FirebaseFirestore.instance
          .collection("group_workouts")
          .doc(widget.workoutId)
          .collection("exercises")
          .doc(exerciseId)
          .collection("results")
          .doc(userId)
          .set({
        "output": output,
        "timestamp": FieldValue.serverTimestamp(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Results submitted successfully!"),
    ));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Group Workout Recording")),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: exercises.map((exercise) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise["name"],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _controllers[exercise["id"]],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Enter Output (${exercise["unit"]})",
                  ),
                ),
                SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitWorkoutResults,
        child: Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}