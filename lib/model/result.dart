import 'package:workout_tracker/model/exercise.dart';

class Result {
  final Exercise exercise;
  final double output;

  const Result({
    required this.exercise,
    required this.output,
  });
}