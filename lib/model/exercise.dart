import 'package:isar/isar.dart';

part 'exercise.g.dart';

@Collection()
class Exercise {
  Id id = Isar.autoIncrement;
  late String name;
  late double target;
  late String unit;

  Exercise({
    required this.name,
    required this.target,
    required this.unit,
  });
}
