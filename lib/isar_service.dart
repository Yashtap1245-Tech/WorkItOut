import 'package:isar/isar.dart';
import '../model/exercise.dart';
import '../model/workout.dart';
import '../model/result.dart';
import '../model/workout_plan.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [ExerciseSchema, WorkoutSchema, ResultSchema, WorkoutPlanSchema],
      directory: dir.path,
    );
  }
}
