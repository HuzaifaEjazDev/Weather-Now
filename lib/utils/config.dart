class AppConfig {
  // WeatherAPI.com - Get free key from https://www.weatherapi.com/
  static const String weatherApiKey = '5825227eeedb4c4eb3d45501250810';

  // OpenWeatherMap fallback
  static const String openWeatherMapKey = 'your_openweather_key_here';

  static bool get isApiKeySet {
    return weatherApiKey.isNotEmpty && weatherApiKey != 'your_weatherapi_key_here';
  }

  static String get apiKeyValidationMessage {
    if (!isApiKeySet) {
      return '''
🌤️ WEATHER API SETUP REQUIRED

To use this weather app, you need a FREE API key:

RECOMMENDED: WeatherAPI.com
1. Go to https://www.weatherapi.com/
2. Click "Sign Up Free"
3. Verify your email
4. Copy your API key from dashboard
5. Replace in lib/utils/config.dart

ALTERNATIVE: OpenWeatherMap
1. Go to https://openweathermap.org/api
2. Sign up and get API key
3. Update service to use OpenWeatherMap

Then restart the app!
''';
    }
    return 'API key is set correctly';
  }
}