import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/workout_details.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/workout_recording_page.dart';

import 'join_team_workout_page.dart';
import 'model/exercise.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Workout History"),
        ),
        body: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            final workouts = workoutProvider.workouts;

            if (workouts.isEmpty) {
              return Center(child: Text("No workouts found"));
            }

            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];

                int successfulCount = workout.results.where((result) {
                  final exercise = workoutProvider.exercises.firstWhere(
                    (e) => e.id == result.exerciseId,
                    orElse: () =>
                        Exercise(name: "Unknown", target: 0, unit: ""),
                  );
                  return exercise.name != "Unknown" &&
                      result.output >= exercise.target;
                }).length;

                return Card(
                  margin: const EdgeInsets.all(8),
                  color: Colors.black12,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      "Workout on ${workout.date.month}/${workout.date.day}",
                    ),
                    subtitle: Text(
                      "${workout.results.length} exercises, $successfulCount successful",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutDetails(workout: workout),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => JoinTeamWorkoutPage()),
              );
            },
            label: Text("Join"),
            icon: Icon(Icons.group),
            backgroundColor: Colors.black12,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WorkoutRecordingPage()),
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.black12,
          ),
        ]));
  }
}
