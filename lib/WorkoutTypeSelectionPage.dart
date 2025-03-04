import 'package:flutter/material.dart';
import 'package:workout_tracker/workout_recording_page.dart';
import 'create_group_workout_page.dart';

class WorkoutTypeSelectionPage extends StatelessWidget {
  const WorkoutTypeSelectionPage({super.key});

  void _navigateToWorkout(BuildContext context, String type) {
    if (type == "Solo") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => WorkoutRecordingPage()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CreateGroupWorkoutPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Workout Type")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWorkoutTypeCard(context, "Solo", Icons.person),
            _buildWorkoutTypeCard(context, "Collective", Icons.group)
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeCard(BuildContext context, String type, IconData icon) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(type, style: TextStyle(fontSize: 18, color: Colors.white)),
        onTap: () => _navigateToWorkout(context, type),
      ),
    );
  }
}