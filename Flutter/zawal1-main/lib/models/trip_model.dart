class TripModel {
  final String destination;
  final String language;
  final bool isSolo;
  final String? groupType;
  final String season;
  final double budget;
  final String activity;
  final int age;

  TripModel({
    required this.destination,
    required this.language,
    required this.isSolo,
    this.groupType,
    required this.season,
    required this.budget,
    required this.activity,
    required this.age,
  });
}
