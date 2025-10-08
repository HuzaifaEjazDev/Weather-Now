import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../utils/config.dart';


class WeatherService {
  // Using WeatherAPI.com (better free tier)
  static const String _baseUrl = 'http://api.weatherapi.com/v1';
  static String get _apiKey => AppConfig.weatherApiKey;

  Future<WeatherData> getWeather(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/forecast.json?key=$_apiKey&q=$lat,$lon&days=5&aqi=no&alerts=no'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return WeatherData.fromWeatherApiJson(jsonData);
      } else if (response.statusCode == 400) {
        throw Exception('Invalid location parameters');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your WeatherAPI.com key.');
      } else if (response.statusCode == 403) {
        throw Exception('API key exceeded its limit or not activated.');
      } else {
        throw Exception('Failed to load weather data. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: Please check your internet connection.');
      } else {
        throw Exception('Failed to load weather: $e');
      }
    }
  }

  Future<List<Location>> searchLocation(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search.json?key=$_apiKey&q=$query'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Location.fromWeatherApiJson(item)).toList();
      } else {
        throw Exception('Failed to search location. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search location: $e');
    }
  }

  // Method to validate API key
  static bool isApiKeySet() {
    return _apiKey.isNotEmpty && _apiKey != 'your_weatherapi_key_here';
  }
}