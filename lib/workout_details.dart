import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/model/result.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:workout_tracker/performance.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:isar/isar.dart';

class WorkoutDetails extends StatelessWidget {
  final Workout workout;

  const WorkoutDetails({super.key, required this.workout});

  Future<Exercise?> _fetchExercise(Isar db, int exerciseId) async {
    return await db.exercises.get(exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();

    final currentWorkout = workoutProvider.workouts.firstWhere(
          (w) =>
      w.date.year == workout.date.year &&
          w.date.month == workout.date.month &&
          w.date.day == workout.date.day,
      orElse: () => workout,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Details"),
        backgroundColor: Colors.black12,
      ),
      body: FutureBuilder(
        future: Future.wait(
          currentWorkout.results.map((result) async {
            final db = await workoutProvider.getDatabase(); // Get Isar instance
            final exercise = await _fetchExercise(db, result.exerciseId);
            return {
              'result': result,
              'exercise': exercise,
            };
          }).toList(),
        ),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No exercise data available"));
          }

          return Stack(
            children: [
              ListView(
                children: snapshot.data!.map((data) {
                  final result = data['result'] as Result;
                  final exercise = data['exercise'] as Exercise?;

                  if (exercise == null) {
                    return ListTile(title: Text("Exercise not found"));
                  }

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.white10,
                    child: ListTile(
                      title: Text(exercise.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Target: ${exercise.target} ${exercise.unit}, Output: ${result.output} ${exercise.unit}'),
                          SizedBox(height: 8),
                          _buildSuccessIndicator(result, exercise),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              Performance(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSuccessIndicator(Result result, Exercise exercise) {
    bool isSuccessful = result.output >= exercise.target;

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