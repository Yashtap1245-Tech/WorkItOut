import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:workout_tracker/model/result.dart';
import 'package:workout_tracker/performance.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:workout_tracker/model/workout.dart';

void main() {

  testWidgets('Performance widget shows "No Recent Workouts" when no workouts are in the past 7 days', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<WorkoutProvider>(
        create: (_) => workoutProvider,
        child: MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const Performance(),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('No Recent Workouts'), findsOneWidget);
    expect(find.text('Performance Score: 0.0'), findsNothing);
  });

  testWidgets('Performance widget shows metric when workouts are present', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();
    final workout = Workout(date: DateTime.now(), results: [
      Result(exercise: Exercise(name: 'Decline Press', target: 100, unit: 'kg'), output: 110),
      Result(exercise: Exercise(name: 'Running', target: 2, unit: 'km'), output: 3),
    ]);

    workoutProvider.addWorkout(workout);
    await tester.pumpWidget(
      ChangeNotifierProvider<WorkoutProvider>(
        create: (_) => workoutProvider,
        child: MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const Performance(),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Performance Score: 57.1'), findsOne);
  });
}
