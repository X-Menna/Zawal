import 'package:flutter/material.dart';
import 'package:zawal/models/recommendation_model.dart';
import 'package:zawal/widgets/result.dart';
class RecommendationScreen extends StatelessWidget {
  final Map<String, dynamic> response;

  const RecommendationScreen({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = recommendation_model.fromJson(response);

    return Scaffold(
      appBar: AppBar(title: const Text('Recommendations')),
      body: RecommendationResultsWidget(data: data),
    );
  }
}


