import '../models/trip_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AIService {
  static Future<Map<String, dynamic>> fetchRecommendations(TripModel trip) async {
    final responseString = await rootBundle.loadString('assets/trip_recommendations.json');
    final data = json.decode(responseString);
    return data;
  }
}


