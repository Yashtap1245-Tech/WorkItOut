import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_tracker/workout_recording_page.dart';

class JoinTeamWorkoutPage extends StatefulWidget {
  @override
  _JoinTeamWorkoutPageState createState() => _JoinTeamWorkoutPageState();
}

class _JoinTeamWorkoutPageState extends State<JoinTeamWorkoutPage> {
  final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;

  Future<void> _joinWorkout() async {
    String inviteCode = _codeController.text.trim();
    if (inviteCode.isEmpty) {
      setState(() {
        _errorMessage = "Please enter an invite code.";
      });
      return;
    }

    DocumentSnapshot workoutDoc = await FirebaseFirestore.instance.collection("workouts").doc(inviteCode).get();

    if (!workoutDoc.exists) {
      setState(() {
        _errorMessage = "Invalid invite code.";
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkoutRecordingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Join Team Workout")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: "Enter Invite Code",
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinWorkout,
              child: Text("Join Workout"),
            ),
          ],
        ),
      ),
    );
  }
}