import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/workout_history_page.dart';
import 'package:workout_tracker/workout_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkoutProvider(),
      child: MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
        useMaterial3: true,
      ),
      home: const WorkoutHistoryPage(),
    ),
    );
  }
}