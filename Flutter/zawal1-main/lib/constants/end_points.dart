class EndPoints {
  // Base URL
  static const String baseUrl = 'https://api.yourbackend.com';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';

  // User
  static const String getUserProfile = '$baseUrl/user/profile';
  static const String updateUserProfile = '$baseUrl/user/update';

  // Trips / Travel
  static const String generateTrip = '$baseUrl/trips/generate';
  static const String getRecommendations = '$baseUrl/trips/recommendations';
  static const String getSafetyReport = '$baseUrl/trips/safety-report';

  // Others
  static const String uploadFile = '$baseUrl/files/upload';
}
