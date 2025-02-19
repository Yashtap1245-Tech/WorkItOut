import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/performance.dart';
import 'workout_provider.dart';
import 'workout_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures async operations before app starts

  final workoutProvider = WorkoutProvider();
  await workoutProvider.loadInitialData(); // Fetch all data before UI loads

  runApp(MyApp(workoutProvider: workoutProvider));
}

class MyApp extends StatelessWidget {
  final WorkoutProvider workoutProvider;

  const MyApp({super.key, required this.workoutProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: workoutProvider, // Provide preloaded data
      child: MaterialApp(
        title: 'Workout App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
          useMaterial3: true,
        ),
        home: WorkoutHistoryPage(),
      ),
    );
  }
}

