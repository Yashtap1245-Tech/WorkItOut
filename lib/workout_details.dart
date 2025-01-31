import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/model/result.dart';
import 'package:workout_tracker/workout_provider.dart';

class WorkoutDetails extends StatelessWidget {
  final Workout workout;

  const WorkoutDetails({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    // Watch the provider to get updates on workouts
    final workoutProvider = context.watch<WorkoutProvider>();

    // Find the workout from the provider or fall back to the passed workout
    final currentWorkout = workoutProvider.workouts.firstWhere(
          (w) =>
      w.date.year == workout.date.year &&
          w.date.month == workout.date.month &&
          w.date.day == workout.date.day,
      orElse: () => workout, // If not found in provider, use the passed workout
    );

    return Scaffold(
      appBar: AppBar(title: Text("Workout Details")),
      body: ListView(
        children: currentWorkout.results.map((result) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.white10,
            child: ListTile(
              title: Text(result.exercise.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Target: ${result.exercise.target} ${result.exercise.unit}, Output: ${result.output} ${result.exercise.unit}'),
                  SizedBox(height: 8),
                  _buildSuccessIndicator(result),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSuccessIndicator(Result result) {
    bool isSuccessful = result.output >= result.exercise.target;

    return Row(
      children: [
        Icon(
          isSuccessful ? Icons.check_circle : Icons.cancel,
          color: isSuccessful ? Colors.green : Colors.red,
        ),
        SizedBox(width: 10),
        Text(
          isSuccessful ? 'Success' : 'Failed',
          style: TextStyle(
            color: isSuccessful ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
