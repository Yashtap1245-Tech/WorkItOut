import 'package:isar/isar.dart';

part 'result.g.dart';

@Collection()
class Result {
  Id id = Isar.autoIncrement;
  late int exerciseId;
  late double output;

  Result({
    required this.exerciseId,
    required this.output,
  });
}
