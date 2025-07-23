class TripModel {
  final String destination;
  final bool isSolo;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String tripType;
  final List<String> feelings;

  TripModel({
    required this.destination,
    required this.isSolo,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.tripType,
    required this.feelings,
  });
}
