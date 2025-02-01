import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/workout_history_page.dart';
import 'package:workout_tracker/workout_provider.dart';

main(){
  testWidgets('WorkoutHistoryPage shows multiple entries when there are multiple Workouts in the shared state', (WidgetTester tester) async {
    final workoutProvider = WorkoutProvider();
    workoutProvider.addWorkout(Workout(date: DateTime.now(), results: []));
    workoutProvider.addWorkout(Workout(date: DateTime.now().subtract(Duration(days: 1)), results: []));

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<WorkoutProvider>.value(
          value: workoutProvider,
          child: WorkoutHistoryPage(),
        ),
      ),
    );

    expect(find.byType(ListTile), findsNWidgets(2));
  });
}