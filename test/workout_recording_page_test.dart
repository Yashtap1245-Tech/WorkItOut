import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/distance_input.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:workout_tracker/model/result.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/model/workout_plan.dart';
import 'package:workout_tracker/repetitions_input.dart';
import 'package:workout_tracker/weight_input.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:workout_tracker/workout_recording_page.dart';

main() {

  testWidgets('WorkoutRecordingPage shows a separate input for each exercise in the workout plan', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => WorkoutProvider(),
          child: WorkoutRecordingPage(),
        ),
      ),
    );

    for (var exercise in workoutPlan.exercises) {
      final exerciseText = find.text(exercise.name);
      expect(exerciseText, findsOneWidget);

      if (exercise.unit == 'reps') {
        expect(find.byType(RepetitionsInput), findsWidgets);
      } else if (exercise.unit == 'kg') {
        expect(find.byType(WeightInput), findsWidgets);
      } else if (exercise.unit == 'km') {
        expect(find.byType(DistanceInput), findsWidgets);
      }
    }
  });

  testWidgets('Fill out all fields and click save adds it in the provider', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<WorkoutProvider>(
        create: (_) => workoutProvider,
        child: MaterialApp(
          home: WorkoutRecordingPage(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '100');
    await tester.enterText(find.byType(TextFormField).at(1), '2');
    await tester.enterText(find.byType(TextFormField).at(2), '150');
    await tester.enterText(find.byType(TextFormField).at(3), '120');
    await tester.tap(find.byIcon(Icons.add).at(0));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add).at(1));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add).at(2));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.add).at(3));
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final newWorkout = workoutProvider.workouts.first;

    expect(newWorkout.results.length, 8);

    expect(newWorkout.results[0].exercise.name, 'Decline Press');
    expect(newWorkout.results[0].output, 100.0); // Should be 100 kg
  });
}