import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'isar_service.dart';
import 'model/workout.dart';
import 'model/workout_plan.dart';
import 'model/exercise.dart';
import 'model/result.dart';

class WorkoutProvider extends ChangeNotifier {
  final IsarService _isarService = IsarService();
  List<Workout> _workouts = [];
  List<WorkoutPlan> _workoutPlans = [];
  List<Exercise> _exercises = [];

  List<Workout> get workouts => _workouts;
  List<WorkoutPlan> get workoutPlans => _workoutPlans;
  List<Exercise> get exercises => _exercises;

  WorkoutProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final db = await _isarService.db;
    _workouts = await db.workouts.where().findAll();
    _workoutPlans = await db.workoutPlans.where().findAll();
    _exercises = await db.exercises.where().findAll();
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    final db = await _isarService.db;
    _workouts = await db.workouts.where().findAll();
    _workoutPlans = await db.workoutPlans.where().findAll();
    _exercises = await db.exercises.where().findAll();
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout, List<Result> results) async {
    final db = await _isarService.db;

    await db.writeTxn(() async {
      workout.id = await db.workouts.put(workout);

      for (var result in results) {
        result.id = await db.results.put(result);
        workout.results.add(result);
      }

      await workout.results.save();
      await db.workouts.put(workout);
    });

    _workouts.add(workout);
    notifyListeners();
  }

  Future<void> addWorkoutPlan(WorkoutPlan plan) async {
    final db = await _isarService.db;
    db.writeTxn(() async {
      await db.workoutPlans.put(plan);
    });
    _workoutPlans.add(plan);
    notifyListeners();
  }

  Future<void> deleteWorkoutPlan(WorkoutPlan plan) async {
    final db = await _isarService.db;
    await db.writeTxn(() async {
      await db.workoutPlans.delete(plan.id);
    });

    _workoutPlans.removeWhere((p) => p.id == plan.id);
    notifyListeners();
  }

  Future<void> addExercise(Exercise exercise) async {
    final db = await _isarService.db;
    db.writeTxn(() async {
      await db.exercises.put(exercise);
    });
    _exercises.add(exercise);
    notifyListeners();
  }

  Future<Isar> getDatabase() async {
    return await _isarService.db;
  }

  Future<void> refreshData() async {
    await loadInitialData();
  }
}
