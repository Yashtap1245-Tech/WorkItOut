import 'package:isar/isar.dart';
import 'result.dart';

part 'workout.g.dart';

@Collection()
class Workout {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date;

  final results = IsarLinks<Result>(); // Store linked results

  Workout({
    required this.date,
  });
}
