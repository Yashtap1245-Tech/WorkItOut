import 'package:isar/isar.dart';

part 'result.g.dart';

@Collection()
class Result {
  Id id = Isar.autoIncrement; // Auto-incrementing ID
  late int exerciseId; // Store the exercise reference
  late double output;

  Result({
    required this.exerciseId,
    required this.output,
  });
}