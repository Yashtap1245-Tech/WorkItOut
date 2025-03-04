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

  Future<List<Map<String, dynamic>>> _fetchWorkoutResults(Isar db) async {
    await workout.results.load();
    List<Map<String, dynamic>> resultsData = [];

    for (var result in workout.results) {
      Exercise? exercise = await db.exercises.get(result.exerciseId);
      if (exercise != null) {
        resultsData.add({'result': result, 'exercise': exercise});
      }
    }
    return resultsData;
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Details"),
        backgroundColor: Colors.black12,
      ),
      body: FutureBuilder(
        future: context
            .read<WorkoutProvider>()
            .getDatabase()
            .then((db) => _fetchWorkoutResults(db)),
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
                  final exercise = data['exercise'] as Exercise;

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
