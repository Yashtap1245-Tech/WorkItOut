import 'package:flutter/material.dart';

import 'model/exercise.dart';
import 'model/workout_plan.dart';

class WorkoutRecordingPage extends StatefulWidget {
  const WorkoutRecordingPage({super.key});

  @override
  State<WorkoutRecordingPage> createState() => _State();
}

class _State extends State<WorkoutRecordingPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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

