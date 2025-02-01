import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/distance_input.dart';
import 'package:workout_tracker/performance.dart';
import 'package:workout_tracker/repetitions_input.dart';
import 'package:workout_tracker/weight_input.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'model/exercise.dart';
import 'model/result.dart';
import 'model/workout.dart';
import 'model/workout_plan.dart';

class WorkoutRecordingPage extends StatefulWidget {
  const WorkoutRecordingPage({super.key});

  @override
  State<WorkoutRecordingPage> createState() => _State();
}
class _State extends State<WorkoutRecordingPage> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  late Map<String, int> _repsCounters;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _repsCounters = {};

    for (var exercise in workoutPlan.exercises) {
      _controllers[exercise.name] = TextEditingController();
      if (exercise.unit == "reps") {
        _repsCounters[exercise.name] = 0;
      }
    }
  }

  void _incrementCounter(String exerciseName) {
    setState(() {
      _repsCounters[exerciseName] = (_repsCounters[exerciseName] ?? 0) + 1;
    });
  }

  void _decrementCounter(String exerciseName) {
    setState(() {
      if (_repsCounters[exerciseName]! > 0) {
        _repsCounters[exerciseName] = (_repsCounters[exerciseName] ?? 0) - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Workout'), backgroundColor: Colors.black12,),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: workoutPlan.exercises.map((exercise) {
                  Widget inputType = Container();

                  if (exercise.unit == "reps") {
                    inputType = RepetitionsInput(
                      counter: _repsCounters[exercise.name] ?? 0,
                      onIncrement: () => _incrementCounter(exercise.name),
                      onDecrement: () => _decrementCounter(exercise.name),
                    );
                  } else if (exercise.unit == "kg") {
                    inputType = WeightInput(controller: _controllers[exercise.name]!);
                  } else if (exercise.unit == "km") {
                    inputType = DistanceInput(controller: _controllers[exercise.name]!);
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(("Target ${exercise.target} ${exercise.unit}"),
                            style: TextStyle(
                              fontSize: 12,
                            )),
                        SizedBox(height: 8),
                        inputType,
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Performance()
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            List<Result> results = [];
            for (var exercise in workoutPlan.exercises) {
              final input = _controllers[exercise.name]?.text;
              if (input != null && input.isNotEmpty) {
                results.add(Result(
                  exercise: exercise,
                  output: double.tryParse(input) ?? 0.0,
                ));
              }
              if (exercise.unit == 'reps') {
                // Use counter value for 'reps' exercises
                final reps = _repsCounters[exercise.name] ?? 0;
                results.add(Result(
                  exercise: exercise,
                  output: reps.toDouble(),
                ));
              }
            }
            final newWorkout = Workout(date: DateTime.now(), results: results);
            context.read<WorkoutProvider>().addWorkout(newWorkout);
            Navigator.of(context).pop();
          }
        },
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
        tooltip: 'Record Workout',
        backgroundColor: Colors.black,
      ),
    );
  }
}


final workoutPlan = WorkoutPlan(
  name: "Chest Workout",
  exercises: [
    Exercise(
      name: "Decline Press",
      target: 100,
      unit: "kg",
    ),
    Exercise(
      name: "Running",
      target: 2,
      unit: "km",
    ),
    Exercise(
      name: "Flat Press",
      target: 150,
      unit: "kg",
    ),
    Exercise(
      name: "Incline Press",
      target: 120,
      unit: "kg",
    ),
    Exercise(
      name: "Machine Fly",
      target: 6,
      unit: "reps",
    ),
    Exercise(
      name: "Cable Crossover",
      target: 15,
      unit: "reps",
    ),
    Exercise(
      name: "Dumble Scoop",
      target: 5,
      unit: "reps",
    ),
    Exercise(
      name: "Push-ups",
      target: 5,
      unit: "reps",
    ),
  ],
);
