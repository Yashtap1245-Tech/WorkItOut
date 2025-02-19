import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:workout_tracker/performance.dart';
import 'workout_provider.dart';
import 'model/exercise.dart';
import 'model/workout_plan.dart';
import 'package:isar/isar.dart';

class AddWorkoutPlanPage extends StatefulWidget {
  const AddWorkoutPlanPage({super.key});

  @override
  State<AddWorkoutPlanPage> createState() => _AddWorkoutPlanPageState();
}

class _AddWorkoutPlanPageState extends State<AddWorkoutPlanPage> {
  final _urlController = TextEditingController();
  bool _loading = false;
  String? _message;

  Future<void> _downloadWorkoutPlan() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> workoutPlanJson = json.decode(response.body);
        final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
        final db = await workoutProvider.getDatabase();

        final workoutPlan = await _parseWorkoutPlan(db, workoutPlanJson);

        await workoutProvider.addWorkoutPlan(workoutPlan);

        setState(() {
          _message = 'Workout plan saved successfully!';
        });
      } else {
        setState(() {
          _message = 'Failed to download workout plan. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Failed to connect. Please check your internet connection.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<WorkoutPlan> _parseWorkoutPlan(Isar db, Map<String, dynamic> json) async {
    final exercises = (json['exercises'] as List).map((exerciseJson) {
      return Exercise(
        name: exerciseJson['name'],
        target: exerciseJson['target'].toDouble(),
        unit: exerciseJson['unit'],
      );
    }).toList();

    await db.writeTxn(() async {
      for (var exercise in exercises) {
        exercise.id = await db.exercises.put(exercise);
      }
    });

    final workoutPlan = WorkoutPlan(name: json['name']);
    workoutPlan.exercises.addAll(exercises);

    await db.writeTxn(() async {
      await db.workoutPlans.put(workoutPlan);
      await workoutPlan.exercises.save();
    });

    return workoutPlan;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Scaffold(
      appBar: AppBar(title: const Text('Download Workout Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter Workout Plan URL',
                errorText: _message != null ? _message : null,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _downloadWorkoutPlan,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Download'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Text(
                _message!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _message == 'Workout plan saved successfully!' ? Colors.green : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
    Performance(),
    ],
    );
  }
}
