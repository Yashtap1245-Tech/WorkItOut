import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:workout_tracker/model/workout.dart';

class Performance extends StatelessWidget {
  const Performance({super.key});

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
              double score = calculatePerformanceScore(workoutProvider.workouts);

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Performance Score: ${score.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double calculatePerformanceScore(List<Workout> workouts) {
    DateTime now = DateTime.now();
    DateTime oneWeekAgo = now.subtract(Duration(days: 7));

    List<Workout> recentWorkouts = workouts.where((workout) {
      return workout.date.isAfter(oneWeekAgo);
    }).toList();

    int totalExercises = 0;
    int exercisesMeetingTarget = 0;

    for (var workout in recentWorkouts) {
      for (var result in workout.results) {
        totalExercises++;
        if (result.output >= result.exercise.target) {
          exercisesMeetingTarget++;
        }
      }
    }

    double workoutFrequencyScore = (recentWorkouts.length / 7) * 50;

    double performanceScore = totalExercises > 0
        ? (exercisesMeetingTarget / totalExercises) * 50
        : 0;

    double totalScore = workoutFrequencyScore + performanceScore;

    return totalScore.clamp(0, 100);
  }
}
