class WeatherData {
  final String location;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final int condition;
  final List<DailyForecast> dailyForecast;
  final String lastUpdated;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.condition,
    required this.dailyForecast,
    required this.lastUpdated,
  });

  factory WeatherData.fromWeatherApiJson(Map<String, dynamic> json) {
    final current = json['current'];
    final location = json['location'];

    // Parse daily forecast
    List<DailyForecast> forecasts = [];
    if (json['forecast'] != null && json['forecast']['forecastday'] != null) {
      forecasts = (json['forecast']['forecastday'] as List).map((day) {
        return DailyForecast.fromWeatherApiJson(day);
      }).toList();
    }

    return WeatherData(
      location: location['name'] ?? 'Unknown Location',
      temperature: (current['temp_c'] ?? 0).toDouble(),
      feelsLike: (current['feelslike_c'] ?? 0).toDouble(),
      humidity: current['humidity'] ?? 0,
      windSpeed: (current['wind_kph'] ?? 0).toDouble() / 3.6, // Convert to m/s
      description: (current['condition']['text'] ?? 'Unknown'),
      icon: _mapWeatherApiIcon(current['condition']['code'] ?? 1000),
      condition: current['condition']['code'] ?? 1000,
      dailyForecast: forecasts,
      lastUpdated: current['last_updated'] ?? '',
    );
  }

  static String _mapWeatherApiIcon(int conditionCode) {
    // WeatherAPI.com condition codes to icon mapping
    if (conditionCode == 1000) return '01d'; // Sunny
    if (conditionCode == 1003) return '02d'; // Partly cloudy
    if (conditionCode == 1006 || conditionCode == 1009) return '03d'; // Cloudy
    if (conditionCode >= 1063 && conditionCode <= 1201) return '10d'; // Rain
    if (conditionCode >= 1210 && conditionCode <= 1225) return '13d'; // Snow
    if (conditionCode >= 1237 && conditionCode <= 1282) return '11d'; // Thunder
    return '01d';
  }

  // Dummy data for testing
  factory WeatherData.dummy() {
    return WeatherData(
      location: 'New York',
      temperature: 22.0,
      feelsLike: 24.0,
      humidity: 65,
      windSpeed: 5.5,
      description: 'Sunny',
      icon: '01d',
      condition: 1000,
      dailyForecast: List.generate(3, (index) => DailyForecast.dummy(index + 1)),
      lastUpdated: DateTime.now().toIso8601String(),
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String icon;
  final int condition;
  final double avgHumidity;
  final double chanceOfRain;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.icon,
    required this.condition,
    required this.avgHumidity,
    required this.chanceOfRain,
  });

  factory DailyForecast.fromWeatherApiJson(Map<String, dynamic> json) {
    final day = json['day'];
    return DailyForecast(
      date: DateTime.parse(json['date']),
      maxTemp: (day['maxtemp_c'] ?? 0).toDouble(),
      minTemp: (day['mintemp_c'] ?? 0).toDouble(),
      description: day['condition']['text'] ?? '',
      icon: WeatherData._mapWeatherApiIcon(day['condition']['code'] ?? 1000),
      condition: day['condition']['code'] ?? 1000,
      avgHumidity: (day['avghumidity'] ?? 0).toDouble(),
      chanceOfRain: (day['daily_chance_of_rain'] ?? 0).toDouble(),
    );
  }

  factory DailyForecast.dummy(int daysFromNow) {
    return DailyForecast(
      date: DateTime.now().add(Duration(days: daysFromNow)),
      maxTemp: 25.0 + daysFromNow,
      minTemp: 15.0 + daysFromNow,
      description: ['Sunny', 'Cloudy', 'Rainy'][daysFromNow % 3],
      icon: ['01d', '02d', '10d'][daysFromNow % 3],
      condition: [1000, 1006, 1063][daysFromNow % 3],
      avgHumidity: 60.0 + (daysFromNow * 5),
      chanceOfRain: [10, 30, 80][daysFromNow % 3].toDouble(),
    );
  }
}