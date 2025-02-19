import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/workout_details.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:isar/isar.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:workout_tracker/workout_recording_page.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({super.key});

  Future<Exercise?> _fetchExercise(Isar db, int exerciseId) async {
    return await db.exercises.get(exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout History"),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return FutureBuilder(
            future: Future.wait(
              workoutProvider.workouts.map((workout) async {
                final db = await workoutProvider.getDatabase();
                List<Map<String, dynamic>> resultsWithExercises = await Future.wait(
                  workout.results.map((result) async {
                    final exercise = await _fetchExercise(db, result.exerciseId);
                    return {
                      'result': result,
                      'exercise': exercise,
                    };
                  }).toList(),
                );
                return {
                  'workout': workout,
                  'results': resultsWithExercises,
                };
              }).toList(),
            ),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No workouts found"));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final workoutData = snapshot.data![index];
                  final workout = workoutData['workout'] as Workout;
                  final resultsWithExercises = workoutData['results'] as List<Map<String, dynamic>>;

                  int successfulCount = resultsWithExercises.where((data) {
                    final result = data['result'] as dynamic;
                    final exercise = data['exercise'] as Exercise?;
                    return exercise != null && result.output >= exercise.target;
                  }).length;

                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: Colors.black12,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                          "Workout on ${workout.date.month}/${workout.date.day}"),
                      subtitle: Text(
                          "${resultsWithExercises.length} exercises, $successfulCount successful"),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WorkoutDetails(workout: workout),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WorkoutRecordingPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.black12,
      ),
    );
  }
}