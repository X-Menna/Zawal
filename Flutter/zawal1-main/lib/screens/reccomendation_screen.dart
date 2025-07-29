import 'package:flutter/material.dart';
import 'package:zawal/models/recommendation_model.dart';
import 'package:zawal/widgets/result.dart';

class RecommendationScreen extends StatelessWidget {
  final Map<String, dynamic> response;

  const RecommendationScreen({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final recommendation_model? parsedData;

    try {
      parsedData = recommendation_model.fromJson(response);
    } catch (e) {
      parsedData = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Trip Result'),
        centerTitle: true,
      ),
      body: parsedData != null
          ? RecommendationResultsWidget(data: parsedData)
          : const Center(
              child: Text(
                "Failed to load recommendation data.",
                style: TextStyle(color: Colors.red),
              ),
            ),
    );
  }
}
