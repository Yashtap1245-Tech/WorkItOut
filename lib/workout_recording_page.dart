import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/add_workout_plan_page.dart';
import 'package:workout_tracker/performance.dart';
import 'package:workout_tracker/repetitions_input.dart';
import 'package:workout_tracker/seconds_input.dart';
import 'package:workout_tracker/weight_input.dart';
import 'package:workout_tracker/workout_provider.dart';
import 'distance_input.dart';
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
  late Map<String, int> _secondsCounters;
  late Map<String, int> _repetitionsCounters;  // Add a new map to handle repetitions
  WorkoutPlan? selectedWorkoutPlan;

  @override
  void initState() {
    super.initState();
    selectedWorkoutPlan = context.read<WorkoutProvider>().workoutPlans[0];

    _controllers = {};
    _secondsCounters = {};
    _repetitionsCounters = {};  // Initialize the repetitions counter

    for (var exercise in selectedWorkoutPlan!.exercises) {
      _controllers[exercise.name] = TextEditingController();
      if (exercise.unit == "seconds") {
        _secondsCounters[exercise.name] = 0;
      } else if (exercise.unit == "repetitions") {  // Initialize repetitions counter
        _repetitionsCounters[exercise.name] = 0;
      }
    }
  }

  void _incrementCounter(String exerciseName) {
    setState(() {
      if (_secondsCounters.containsKey(exerciseName)) {
        _secondsCounters[exerciseName] = (_secondsCounters[exerciseName] ?? 0) + 1;
      } else if (_repetitionsCounters.containsKey(exerciseName)) {
        _repetitionsCounters[exerciseName] = (_repetitionsCounters[exerciseName] ?? 0) + 1;
      }
    });
  }

  void _decrementCounter(String exerciseName) {
    setState(() {
      if (_secondsCounters.containsKey(exerciseName) && (_secondsCounters[exerciseName]! > 0)) {
        _secondsCounters[exerciseName] = (_secondsCounters[exerciseName] ?? 0) - 1;
      } else if (_repetitionsCounters.containsKey(exerciseName) && (_repetitionsCounters[exerciseName]! > 0)) {
        _repetitionsCounters[exerciseName] = (_repetitionsCounters[exerciseName] ?? 0) - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Workout'), backgroundColor: Colors.black12),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Consumer<WorkoutProvider>(
                  builder: (context, provider, child) {
                    selectedWorkoutPlan = provider.workoutPlans.isNotEmpty
                        ? provider.workoutPlans[0]
                        : null;

                    return DropdownButton<WorkoutPlan>(
                      value: selectedWorkoutPlan,
                      items: provider.workoutPlans.map((plan) {
                        return DropdownMenuItem(
                          value: plan,
                          child: Text(plan.name),
                        );
                      }).toList(),
                      onChanged: (newPlan) {
                        setState(() {
                          selectedWorkoutPlan = newPlan;
                          _controllers.clear();
                          _secondsCounters.clear();
                          _repetitionsCounters.clear();
                          for (var exercise in selectedWorkoutPlan!.exercises) {
                            _controllers[exercise.name] = TextEditingController();
                            if (exercise.unit == "seconds") {
                              _secondsCounters[exercise.name] = 0;
                            } else if (exercise.unit == "repetitions") {
                              _repetitionsCounters[exercise.name] = 0;
                            }
                          }
                        });
                      },
                    );
                  },
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedWorkoutPlan?.exercises.map((exercise) {
                          Widget inputType = Container();

                          if (exercise.unit == "seconds") {
                            inputType = SecondsInput(
                              counter: _secondsCounters[exercise.name] ?? 0,
                              onIncrement: () => _incrementCounter(exercise.name),
                              onDecrement: () => _decrementCounter(exercise.name),
                              controller: _controllers[exercise.name]!,
                            );
                          } else if (exercise.unit == "kg") {
                            inputType = WeightInput(controller: _controllers[exercise.name]!);
                          } else if (exercise.unit == "meters") {
                            inputType = DistanceInput(controller: _controllers[exercise.name]!);
                          } else if (exercise.unit == "repetitions") {
                            inputType = RepetitionsInput(
                              counter: _repetitionsCounters[exercise.name] ?? 0,
                              onIncrement: () => _incrementCounter(exercise.name),
                              onDecrement: () => _decrementCounter(exercise.name),
                              controller: _controllers[exercise.name]!,
                            );
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
                                Text("Target ${exercise.target} ${exercise.unit}",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                SizedBox(height: 8),
                                inputType,
                              ],
                            ),
                          );
                        }).toList() ?? [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Performance(),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  List<Result> results = [];
                  for (var exercise in selectedWorkoutPlan!.exercises) {
                    final input = _controllers[exercise.name]?.text;
                    if (input != null && input.isNotEmpty) {
                      results.add(Result(
                        exercise: exercise,
                        output: double.tryParse(input) ?? 0.0,
                      ));
                    }
                    if (exercise.unit == 'seconds') {
                      final seconds = _secondsCounters[exercise.name] ?? 0;
                      results.add(Result(
                        exercise: exercise,
                        output: seconds.toDouble(),
                      ));
                    }
                    if (exercise.unit == 'repetitions') {
                      final repetitions = _repetitionsCounters[exercise.name] ?? 0;
                      results.add(Result(
                        exercise: exercise,
                        output: repetitions.toDouble(),
                      ));
                    }
                  }
                  final newWorkout = Workout(date: DateTime.now(), results: results);
                  context.read<WorkoutProvider>().addWorkout(newWorkout);
                  Navigator.of(context).pop();
                }
              },
              child: Icon(Icons.save, color: Colors.white),
              tooltip: 'Record Workout',
              backgroundColor: Colors.black,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddWorkoutPlanPage()),
                );
              },
              child: Icon(Icons.download, color: Colors.white),
              backgroundColor: Colors.black,
              tooltip: 'Download Workout Plan',
            ),
          ),
        ],
      ),
    );
  }
}