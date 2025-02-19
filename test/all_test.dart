import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/model/exercise.dart';
import 'package:workout_tracker/model/result.dart';
import 'package:workout_tracker/performance.dart';
import 'package:workout_tracker/workout_details.dart';
import 'package:workout_tracker/workout_history_page.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'package:workout_tracker/model/workout.dart';
import 'package:isar/isar.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'all_test.mocks.dart';

@GenerateMocks([Isar, WorkoutProvider])
void main() {
  late MockWorkoutProvider mockWorkoutProvider;
  late MockIsar mockIsar;

  setUp(() {
    mockWorkoutProvider = MockWorkoutProvider();
    mockIsar = MockIsar();
  });

  testWidgets(
      'Performance widget shows "No Recent Workouts" when no workouts are in the past 7 days',
          (WidgetTester tester) async {
        when(mockWorkoutProvider.workouts).thenReturn([]);
        when(mockWorkoutProvider.getDatabase()).thenAnswer((_) async => mockIsar);

        await tester.pumpWidget(
          ChangeNotifierProvider<WorkoutProvider>.value(
            value: mockWorkoutProvider,
            child: const MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: [Performance()],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('No Recent Workouts'), findsOneWidget);
        expect(find.textContaining('Performance Score:'), findsNothing);
      });

  testWidgets('Performance widget shows metric when workouts are present',
          (WidgetTester tester) async {
        final workout = Workout(date: DateTime.now());
        final result1 = Result(exerciseId: 1, output: 110);
        final result2 = Result(exerciseId: 2, output: 3);
        workout.results.add(result1);
        workout.results.add(result2);

        when(mockWorkoutProvider.workouts).thenReturn([workout]);
        when(mockWorkoutProvider.getDatabase()).thenAnswer((_) async => mockIsar);

        await tester.pumpWidget(
          ChangeNotifierProvider<WorkoutProvider>.value(
            value: mockWorkoutProvider,
            child: const MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: [Performance()],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.textContaining('Performance Score:'), findsOneWidget);
      });

  testWidgets('No workout history is displayed when there are no entries',
          (WidgetTester tester) async {
        when(mockWorkoutProvider.workouts).thenReturn([]);
        when(mockWorkoutProvider.getDatabase()).thenAnswer((_) async => mockIsar);

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<WorkoutProvider>.value(
              value: mockWorkoutProvider,
              child: const WorkoutHistoryPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text("No workouts found"), findsOneWidget);
      });

  testWidgets(
      'Performance widget shows "No Recent Workouts" when no workouts are in the past 7 days',
          (WidgetTester tester) async {
        when(mockWorkoutProvider.workouts).thenReturn([]);
        when(mockWorkoutProvider.getDatabase()).thenAnswer((_) async => mockIsar);

        await tester.pumpWidget(
          ChangeNotifierProvider<WorkoutProvider>.value(
            value: mockWorkoutProvider,
            child: const MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: [Performance()],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('No Recent Workouts'), findsOneWidget);
        expect(find.textContaining('Performance Score:'), findsNothing);
      });

}
