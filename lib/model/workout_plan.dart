import 'package:isar/isar.dart';
import 'exercise.dart';

part 'workout_plan.g.dart';

@Collection()
class WorkoutPlan {
  Id id = Isar.autoIncrement;
  late String name;

  final exercises = IsarLinks<Exercise>();

  WorkoutPlan({
    required this.name,
  });

  Future<void> deleteWorkoutPlan(Isar db, WorkoutPlan plan) async {
    await db.writeTxn(() async {
      await plan.exercises.load();
      for (var exercise in plan.exercises) {
        await db.exercises.delete(exercise.id);
      }
      await db.workoutPlans.delete(plan.id);
    });
  }

}