class Exercise {
  final String name;
  final double target;
  final String unit;

  const Exercise({
    required this.name,
    required this.target,
    required this.unit,
  });

  double get output => this.target;
}