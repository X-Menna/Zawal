import 'package:flutter/material.dart';
import 'package:zawal/models/recommendation_model.dart';

class RecommendationResultsWidget extends StatelessWidget {
  final RecommendationResponse data;

  const RecommendationResultsWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status: ${data.status}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Message: ${data.message}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Text("Safety Report:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("Safety Score: ${data.safetyReport.safetyScore}"),
          Text("Capital Checked: ${data.safetyReport.capitalChecked}"),
          Text("Data Source: ${data.safetyReport.dataSource}"),
          Text("Last Updated: ${data.safetyReport.lastUpdated}"),
          const Divider(),
          Text("Alternatives:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...data.alternatives.map((alt) => Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Country: ${alt.country}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Score: ${alt.score.toStringAsFixed(2)}"),
                  Text("Kid Friendly: ${alt.details.scores.kidFriendly}"),
                  Text("Season: ${alt.details.scores.season}"),
                  Text("Preference Match: ${alt.details.scores.preferenceMatch.toStringAsFixed(2)}"),
                  Text("Safety Score: ${alt.details.safety.safetyScore}"),
                  Text("AI Analysis Error: ${alt.details.aiAnalysis.error}"),
                  Text("AI Details: ${alt.details.aiAnalysis.details}"),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}



