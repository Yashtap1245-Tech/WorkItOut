import 'package:flutter/material.dart';
import 'model/exercise.dart';
import 'model/workout.dart';
import 'model/workout_plan.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];
  List<WorkoutPlan> _workoutPlans = [workoutPlan]; // Add hardcoded plan as default

  // Getter for workouts
  List<Workout> get workouts => _workouts;

  // Getter for workout plans
  List<WorkoutPlan> get workoutPlans => _workoutPlans;

  // Method to add a completed workout
  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }

  // Method to add a workout plan
  void addWorkoutPlan(WorkoutPlan plan) {
    _workoutPlans.add(plan);
    notifyListeners();
  }
}

// Hardcoded workout plan for reference
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
      target: 2000,
      unit: "meters",
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
      target: 60,
      unit: "seconds",
    ),
    Exercise(
      name: "Cable Crossover",
      target: 150,
      unit: "seconds",
    ),
    Exercise(
      name: "Dumble Scoop",
      target: 80,
      unit: "seconds",
    ),
    Exercise(
      name: "Push-ups",
      target: 150,
      unit: "seconds",
    ),
  ],
);
