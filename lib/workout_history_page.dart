import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/workout_details.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:workout_tracker/workout_recording_page.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout App"),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return ListView.builder(
            itemCount: workoutProvider.workouts.length,
            itemBuilder: (context, index) {
              final workout = workoutProvider.workouts[index];
              int successfulCount = workout.results
                  .where((result) => result.output >= result.exercise.target)
                  .length;
              return Card(
                margin: const EdgeInsets.all(8),
                color: Colors.black12,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                      "Workout on ${workout.date.month}/${workout.date.day}"),
                  subtitle: Text(
                      "${workout.results.length} exercises, $successfulCount successful"),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                WorkoutDetails(workout: workout)),
                      );
                    },
                  ),
                ),
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
        selectedItemColor: Colors.black,
      ),
    );
  }
}
