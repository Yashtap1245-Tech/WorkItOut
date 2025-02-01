import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/model/result.dart';
import 'package:workout_tracker/workout_details.dart';
import 'package:workout_tracker/workout_provider.dart';

main() {

  testWidgets('WorkoutDetails shows specifics of exercises and their output', (WidgetTester tester) async {
    final workout = Workout(date: DateTime.now(), results: [
      Result(exercise: Exercise(name: 'Decline Press', target: 100, unit: 'kg'), output: 110),
      Result(exercise: Exercise(name: 'Running', target: 2, unit: 'km'), output: 3),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<WorkoutProvider>(
          create: (_) => WorkoutProvider()..addWorkout(workout),
          child: WorkoutDetails(workout: workout),
        ),
      ),
    );

    // Wait for the widget tree to settle
    await tester.pumpAndSettle();

    expect(find.text('Decline Press'), findsOneWidget);
    expect(find.text('Target: 100.0 kg, Output: 110.0 kg'), findsOneWidget);

    expect(find.text('Running'), findsOneWidget);
    expect(find.text('Target: 2.0 km, Output: 3.0 km'), findsOneWidget);
  });
}
