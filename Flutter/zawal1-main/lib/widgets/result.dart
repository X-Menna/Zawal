import 'package:flutter/material.dart';
import 'package:zawal/models/recommendation_model.dart';

class RecommendationResultsWidget extends StatelessWidget {
  final recommendation_model data;

  const RecommendationResultsWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final prefs = data.preferences;

    if (prefs == null) {
      return const Center(child: Text("No preferences found."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("User Preferences", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text("Country: ${prefs.country ?? 'N/A'}"),
          Text("Budget: ${prefs.budget ?? 'N/A'}"),
          Text("Age: ${prefs.age ?? 'N/A'}"),
          Text("Activities: ${prefs.activities?.join(', ') ?? 'N/A'}"),
          Text("Kid Friendly: ${prefs.isKidFriendlyRequired == 1 ? 'Yes' : 'No'}"),
          Text("Solo Travel: ${prefs.isSoloTravel == 1 ? 'Yes' : 'No'}"),
          Text("Language: ${prefs.language ?? 'N/A'}"),
          Text("Season: ${prefs.season ?? 'N/A'}"),
          const SizedBox(height: 10),
          Text("Created At: ${prefs.createdAt ?? 'N/A'}"),
          Text("Updated At: ${prefs.updatedAt ?? 'N/A'}"),
        ],
      ),
    );
  }
}
