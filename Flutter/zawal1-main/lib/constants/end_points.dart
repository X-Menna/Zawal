class EndPoints {
  // Base URL

  // static const String baseUrl = 'https://api.yourbackend.com';
  
  static const String baseUrl = 'http://localhost:4000';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';

  // User
  static const String generateTrip = '$baseUrl/api/user_preferences';


}
