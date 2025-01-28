import 'package:workout_tracker/model/result.dart';

class Workout {
  final DateTime date;
  final List<Result> results;

  const Workout({
    required this.date,
    required this.results,
  });
}