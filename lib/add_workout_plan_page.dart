import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'workout_provider.dart';
import 'model/exercise.dart';
import 'model/workout_plan.dart';

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
        final workoutPlan = _parseWorkoutPlan(workoutPlanJson);

        context.read<WorkoutProvider>().addWorkoutPlan(workoutPlan);

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

  WorkoutPlan _parseWorkoutPlan(Map<String, dynamic> json) {
    final exercises = (json['exercises'] as List).map((exerciseJson) {
      return Exercise(
        name: exerciseJson['name'],
        target: exerciseJson['target'].toDouble(),
        unit: exerciseJson['unit'],
      );
    }).toList();

    return WorkoutPlan(
      name: json['name'],
      exercises: exercises,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
