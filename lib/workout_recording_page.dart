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
  late Map<String, int> _repetitionsCounters;
  WorkoutPlan? selectedWorkoutPlan;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _secondsCounters = {};
    _repetitionsCounters = {};
    _loadWorkoutPlans();
  }

  Future<void> _loadWorkoutPlans() async {
    final provider = context.read<WorkoutProvider>();
    await provider.refreshData();
    if (provider.workoutPlans.isNotEmpty) {
      selectedWorkoutPlan = provider.workoutPlans.first;
      await _loadExercises();
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _loadExercises() async {
    if (selectedWorkoutPlan != null) {
      final db = await context.read<WorkoutProvider>().getDatabase();
      await selectedWorkoutPlan!.exercises.load();
      _initializeControllers();
      setState(() {});
    }
  }

  void _initializeControllers() {
    _controllers.clear();
    if (selectedWorkoutPlan != null &&
        selectedWorkoutPlan!.exercises.isNotEmpty) {
      for (var exercise in selectedWorkoutPlan!.exercises) {
        _controllers[exercise.name] = TextEditingController();
        if (exercise.unit == "seconds") {
          _secondsCounters[exercise.name] = 0;
        } else if (exercise.unit == "repetitions") {
          _repetitionsCounters[exercise.name] = 0;
        }
      }
    }
  }

  void _incrementCounter(String exerciseName) {
    setState(() {
      if (_secondsCounters.containsKey(exerciseName)) {
        _secondsCounters[exerciseName] =
            (_secondsCounters[exerciseName] ?? 0) + 1;
        _controllers[exerciseName]?.text =
            _secondsCounters[exerciseName].toString();
      } else if (_repetitionsCounters.containsKey(exerciseName)) {
        _repetitionsCounters[exerciseName] =
            (_repetitionsCounters[exerciseName] ?? 0) + 1;
        _controllers[exerciseName]?.text =
            _repetitionsCounters[exerciseName].toString();
      }
    });
  }

  void _decrementCounter(String exerciseName) {
    setState(() {
      if (_secondsCounters.containsKey(exerciseName) &&
          (_secondsCounters[exerciseName]! > 0)) {
        _secondsCounters[exerciseName] =
            (_secondsCounters[exerciseName] ?? 0) - 1;
        _controllers[exerciseName]?.text =
            _secondsCounters[exerciseName].toString();
      } else if (_repetitionsCounters.containsKey(exerciseName) &&
          (_repetitionsCounters[exerciseName]! > 0)) {
        _repetitionsCounters[exerciseName] =
            (_repetitionsCounters[exerciseName] ?? 0) - 1;
        _controllers[exerciseName]?.text =
            _repetitionsCounters[exerciseName].toString();
      }
    });
  }

  Future<void> _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      final workoutProvider = context.read<WorkoutProvider>();
      final db = await workoutProvider.getDatabase();

      final newWorkout = Workout(date: DateTime.now());

      await db.writeTxn(() async {
        newWorkout.id = await db.workouts.put(newWorkout);
      });

      final List<Result> results = [];

      for (var exercise in selectedWorkoutPlan!.exercises) {
        final input = _controllers[exercise.name]?.text;
        double output = 0.0;

        if (input != null && input.isNotEmpty) {
          output = double.tryParse(input) ?? 0.0;
        }

        if (exercise.unit == 'repetitions' &&
            (input == null || input.isEmpty)) {
          output = _repetitionsCounters[exercise.name]?.toDouble() ?? 0.0;
        }

        if (exercise.unit == 'seconds' && (input == null || input.isEmpty)) {
          output = _secondsCounters[exercise.name]?.toDouble() ?? 0.0;
        }

        final result = Result(
          exerciseId: exercise.id,
          output: output,
        );

        await db.writeTxn(() async {
          result.id = await db.results.put(result);
          newWorkout.results.add(result);
        });

        results.add(result);
      }

      await db.writeTxn(() async {
        await db.workouts.put(newWorkout);
      });

      workoutProvider.addWorkout(newWorkout, results);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Workout'),
        backgroundColor: Colors.black12,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Consumer<WorkoutProvider>(
                        builder: (context, provider, child) {
                          return Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<WorkoutPlan>(
                                  value: provider.workoutPlans
                                          .contains(selectedWorkoutPlan)
                                      ? selectedWorkoutPlan
                                      : null,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: "Select Workout Plan",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                  ),
                                  items: provider.workoutPlans.map((plan) {
                                    return DropdownMenuItem(
                                      value: plan,
                                      child: Text(plan.name,
                                          style: TextStyle(fontSize: 16)),
                                    );
                                  }).toList(),
                                  onChanged: (newPlan) async {
                                    setState(() {
                                      selectedWorkoutPlan = newPlan;
                                      _controllers.clear();
                                      _secondsCounters.clear();
                                      _repetitionsCounters.clear();
                                    });
                                    await _loadExercises();
                                  },
                                ),
                              ),
                              if (selectedWorkoutPlan != null)
                                Flexible(
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Confirm Delete"),
                                          content: Text(
                                              "Are you sure you want to delete this workout plan?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmed ?? false) {
                                        await provider.deleteWorkoutPlan(
                                            selectedWorkoutPlan!);
                                        setState(() {
                                          selectedWorkoutPlan =
                                              provider.workoutPlans.isNotEmpty
                                                  ? provider.workoutPlans.first
                                                  : null;
                                        });
                                      }
                                    },
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: selectedWorkoutPlan?.exercises
                                      .map((exercise) {
                                    Widget inputType = Container();

                                    if (exercise.unit == "seconds") {
                                      inputType = SecondsInput(
                                        counter:
                                            _secondsCounters[exercise.name] ??
                                                0,
                                        onIncrement: () =>
                                            _incrementCounter(exercise.name),
                                        onDecrement: () =>
                                            _decrementCounter(exercise.name),
                                        controller:
                                            _controllers[exercise.name]!,
                                      );
                                    } else if (exercise.unit == "kg") {
                                      inputType = WeightInput(
                                          controller:
                                              _controllers[exercise.name]!);
                                    } else if (exercise.unit == "meters") {
                                      inputType = DistanceInput(
                                          controller:
                                              _controllers[exercise.name]!);
                                    } else if (exercise.unit == "repetitions") {
                                      inputType = RepetitionsInput(
                                        counter: _repetitionsCounters[
                                                exercise.name] ??
                                            0,
                                        onIncrement: () =>
                                            _incrementCounter(exercise.name),
                                        onDecrement: () =>
                                            _decrementCounter(exercise.name),
                                        controller:
                                            _controllers[exercise.name]!,
                                      );
                                    }

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exercise.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                              "Target ${exercise.target} ${exercise.unit}",
                                              style: TextStyle(fontSize: 12)),
                                          SizedBox(height: 8),
                                          inputType,
                                        ],
                                      ),
                                    );
                                  }).toList() ??
                                  [],
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
      floatingActionButton: Stack(children: [
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _saveWorkout,
            child: Icon(Icons.save, color: Colors.white),
            backgroundColor: Colors.black,
          ),
        ),
        Positioned(
          bottom: 16,
          left: 20,
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
      ]),
    );
  }
}
