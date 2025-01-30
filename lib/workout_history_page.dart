import 'package:flutter/material.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:workout_tracker/model/result.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/workout_details.dart';
import 'package:workout_tracker/workout_recording_page.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout App"),
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          int successfulCount = workout.results
              .where((result) => result.output >= result.exercise.target)
              .length;
          return Card(
            margin: const EdgeInsets.all(8),
            color: Colors.orangeAccent,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text("Workout on ${workout.date.month}/${workout.date.day}"),
              subtitle: Text(
                  "${workout.results.length} exercises, $successfulCount successful"),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => WorkoutDetails(workout: workout)
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()
      {
        Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => WorkoutRecordingPage()
        ),
      );
      },
      child: const Icon(Icons.add),),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}

final List<Workout> workouts = [
  Workout(
    date: DateTime(2025, 1, 13),
    results: [
      Result(exercise: Exercise(name: "20 Pull-Ups", target: 20, unit: "reps"), output: 22),
      Result(exercise: Exercise(name: "Running 5 Km", target: 5, unit: "km"), output: 4.8),
    ],
  ),
  Workout(
    date: DateTime(2025, 10, 15),
    results: [
      Result(exercise: Exercise(name: "30 Chest reps", target: 30, unit: "reps"), output: 30),
      Result(exercise: Exercise(name: "Running 5 Km", target: 5, unit: "km"), output: 5.2),
    ],
  ),
];