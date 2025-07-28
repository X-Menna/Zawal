class RecommendationResponse {
  final String status;
  final String message;
  final SafetyReport safetyReport;
  final List<Alternative> alternatives;

  RecommendationResponse({
    required this.status,
    required this.message,
    required this.safetyReport,
    required this.alternatives,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      status: json['Status'],
      message: json['Message'],
      safetyReport: SafetyReport.fromJson(json['Safety_report']),
      alternatives: (json['Alternatives'] as List)
          .map((item) => Alternative.fromJson(item))
          .toList(),
    );
  }
}

class SafetyReport {
  final double safetyScore;
  final String safetyMessage;
  final List<dynamic> weatherAlerts;
  final String dataSource;
  final String lastUpdated;
  final String capitalChecked;

  SafetyReport({
    required this.safetyScore,
    required this.safetyMessage,
    required this.weatherAlerts,
    required this.dataSource,
    required this.lastUpdated,
    required this.capitalChecked,
  });

  factory SafetyReport.fromJson(Map<String, dynamic> json) {
    return SafetyReport(
      safetyScore: (json['safety_score'] as num).toDouble(),
      safetyMessage: json['safety_message'],
      weatherAlerts: json['weather_alerts'],
      dataSource: json['data_source'],
      lastUpdated: json['last_updated'],
      capitalChecked: json['capital_checked'],
    );
  }
}

class Alternative {
  final String country;
  final double score;
  final Details details;

  Alternative({
    required this.country,
    required this.score,
    required this.details,
  });

  factory Alternative.fromJson(Map<String, dynamic> json) {
    return Alternative(
      country: json['country'],
      score: (json['score'] as num).toDouble(),
      details: Details.fromJson(json['details']),
    );
  }
}

class Details {
  final SafetyReport safety;
  final Scores scores;
  final AiAnalysis aiAnalysis;

  Details({
    required this.safety,
    required this.scores,
    required this.aiAnalysis,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      safety: SafetyReport.fromJson(json['safety']),
      scores: Scores.fromJson(json['scores']),
      aiAnalysis: AiAnalysis.fromJson(json['aiAnalysis']),
    );
  }
}

class Scores {
  final double overall;
  final double preferenceMatch;
  final String budget;
  final String season;
  final String kidFriendly;

  Scores({
    required this.overall,
    required this.preferenceMatch,
    required this.budget,
    required this.season,
    required this.kidFriendly,
  });

  factory Scores.fromJson(Map<String, dynamic> json) {
    return Scores(
      overall: (json['overall'] as num).toDouble(),
      preferenceMatch: (json['preferenceMatch'] as num).toDouble(),
      budget: json['budget'],
      season: json['season'],
      kidFriendly: json['kidFriendly'],
    );
  }
}

class AiAnalysis {
  final String error;
  final String details;

  AiAnalysis({
    required this.error,
    required this.details,
  });

  factory AiAnalysis.fromJson(Map<String, dynamic> json) {
    return AiAnalysis(
      error: json['error'] ?? 'No error',
      details: json['details'] ?? 'No details',
    );
  }
}
