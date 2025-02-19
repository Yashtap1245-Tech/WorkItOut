import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:isar/isar.dart';

class Performance extends StatelessWidget {
  const Performance({super.key});

  Future<Exercise?> _fetchExercise(Isar db, int exerciseId) async {
    return await db.exercises.get(exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 10,
      child: Card(
        color: Colors.black,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<WorkoutProvider>(
            builder: (context, workoutProvider, child) {
              return FutureBuilder<double>(
                future: calculatePerformanceScore(workoutProvider),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Calculating...',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    );
                  }

                  double score = snapshot.data ?? 0.0;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      score == 0
                          ? Text(
                        'No Recent Workouts',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                          : Text(
                        'Performance Score: ${score.toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<double> calculatePerformanceScore(WorkoutProvider workoutProvider) async {
    final db = await workoutProvider.getDatabase();
    DateTime now = DateTime.now();
    DateTime oneWeekAgo = now.subtract(Duration(days: 7));

    List<Workout> recentWorkouts = workoutProvider.workouts.where((workout) {
      return workout.date.isAfter(oneWeekAgo);
    }).toList();

    int totalExercises = 0;
    int exercisesMeetingTarget = 0;

    for (var workout in recentWorkouts) {
      for (var result in workout.results) {
        totalExercises++;
        Exercise? exercise = await _fetchExercise(db, result.exerciseId);
        if (exercise != null && result.output >= exercise.target) {
          exercisesMeetingTarget++;
        }
      }
    }

    double workoutFrequencyScore = (recentWorkouts.length / 7) * 50;
    double performanceScore = totalExercises > 0
        ? (exercisesMeetingTarget / totalExercises) * 50
        : 0;

    return (workoutFrequencyScore + performanceScore).clamp(0, 100);
  }
}