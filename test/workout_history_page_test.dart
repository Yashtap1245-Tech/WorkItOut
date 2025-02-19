import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:workout_tracker/workout_history_page.dart';
import 'package:workout_tracker/workout_provider.dart';

class MockIsar extends Mock implements Isar {}

class MockWorkoutProvider extends Mock implements WorkoutProvider {
  @override
  List<Workout> get workouts => super
      .noSuchMethod(Invocation.getter(#workouts), returnValue: <Workout>[]);
}

void main() {
  testWidgets('No tile is load on zero workout entries', (WidgetTester tester) async {
    final mockWorkoutProvider = MockWorkoutProvider();
    when(mockWorkoutProvider.workouts).thenReturn(<Workout>[]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<WorkoutProvider>.value(
          value: mockWorkoutProvider,
          child: WorkoutHistoryPage(),
        ),
      ),
    );

    expect(find.byType(ListTile), findsNWidgets(0));
  });
}
