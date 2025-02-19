import 'package:isar/isar.dart';
import 'dart:io';
import '../model/exercise.dart';
import '../model/workout.dart';
import '../model/result.dart';
import '../model/workout_plan.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = Directory.systemTemp.path; // Flutter’s default temporary storage
    return Isar.open(
      [ExerciseSchema, WorkoutSchema, ResultSchema, WorkoutPlanSchema],
      directory: dir, // Persistent storage without path_provider
    );
  }
}
