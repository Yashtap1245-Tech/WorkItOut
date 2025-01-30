import 'package:flutter/material.dart';
import 'package:workout_tracker/distance_input.dart';
import 'package:workout_tracker/repetitions_input.dart';
import 'package:workout_tracker/weight_input.dart';
import 'model/exercise.dart';
import 'model/workout_plan.dart';

class WorkoutRecordingPage extends StatefulWidget {
  const WorkoutRecordingPage({super.key});

  @override
  State<WorkoutRecordingPage> createState() => _State();
}

class _State extends State<WorkoutRecordingPage> {

  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;

  @override
  @override
  void initState() {
    super.initState();
    _controllers = {};

    for(var exercise in workoutPlan.exercises){
      _controllers[exercise.name] = TextEditingController();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: workoutPlan.exercises.map((exercise) {
                Widget inputType = Container();

                if(exercise.unit == "reps")
                  inputType = RepetitionsInput();
                else if(exercise.unit == "kg")
                  inputType = WeightInput();
                else if(exercise.unit == "km")
                  inputType = DistanceInput();

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
        tooltip: 'Save Workout',
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
        target: 30,
        unit: "reps",
      ),
      Exercise(
        name: "Cable Crossover",
        target: 15,
        unit: "reps",
      ),
      Exercise(
        name: "Dumble Scoop",
        target: 50,
        unit: "reps",
      ),
      Exercise(
        name: "Push-ups",
        target: 50,
        unit: "reps",
      ),
    ],
);

