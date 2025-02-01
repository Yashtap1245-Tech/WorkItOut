import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
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
                const Performance(), // The widget to be tested
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('No Recent Workouts'), findsOneWidget);
    expect(find.text('Performance Score: 0.0'), findsNothing);
  });

}
