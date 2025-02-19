import 'package:isar/isar.dart';
import 'exercise.dart';

part 'workout_plan.g.dart';

@Collection()
class WorkoutPlan {
  Id id = Isar.autoIncrement;
  late String name;

  final exercises = IsarLinks<Exercise>(); // Stores a list of exercises

  WorkoutPlan({
    required this.name,
  });
}