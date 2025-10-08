import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherData? _currentWeather;
  List<DailyForecast> _dailyForecast = [];
  bool _isLoading = false;
  String _error = '';

  WeatherData? get currentWeather => _currentWeather;
  List<DailyForecast> get dailyForecast => _dailyForecast;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final weather = await _weatherService.getWeather(lat, lon);
      // final forecast = await _weatherService.getDailyForecast(lat, lon);

      _currentWeather = weather;
      // _dailyForecast = forecast;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCurrentLocationWeather() async {
    try {
      final position = await _locationService.getCurrentLocation();
      await fetchWeatherByLocation(position.latitude, position.longitude);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> searchAndSetLocation(String query) async {
    try {
      final locations = await _weatherService.searchLocation(query);
      if (locations.isNotEmpty) {
        await fetchWeatherByLocation(locations.first.lat, locations.first.lon);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}