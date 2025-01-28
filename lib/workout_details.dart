import 'package:flutter/material.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/model/result.dart';

class WorkoutDetails extends StatelessWidget {
  final Workout workout;

  const WorkoutDetails({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: workout.results.map((result) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(result.exercise.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Target: ${result.exercise.target} ${result.exercise.unit}, Output: ${result.output} ${result.exercise.unit}'),
                SizedBox(height: 8),
                _buildSuccessIndicator(result),
              ],
            ),
          ),
        );
      }).toList(),
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
