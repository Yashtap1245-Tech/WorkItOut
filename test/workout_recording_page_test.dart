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


}