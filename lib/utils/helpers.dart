import 'package:flutter/material.dart';


class WeatherHelpers {
  static Color getWeatherColor(int condition) {
    if (condition >= 200 && condition < 300) {
      return Colors.deepPurple; // Thunderstorm
    } else if (condition >= 300 && condition < 600) {
      return Colors.blue; // Rain
    } else if (condition >= 600 && condition < 700) {
      return Colors.blueGrey; // Snow
    } else if (condition >= 700 && condition < 800) {
      return Colors.grey; // Atmosphere
    } else if (condition == 800) {
      return Colors.orange; // Clear
    } else {
      return Colors.lightBlue; // Clouds
    }
  }

  static String getWeatherAnimation(int condition) {
    if (condition >= 200 && condition < 300) {
      return 'assets/animations/thunderstorm.json';
    } else if (condition >= 300 && condition < 600) {
      return 'assets/animations/rainy.json';
    } else if (condition >= 600 && condition < 700) {
      return 'assets/animations/snow.json';
    } else if (condition >= 700 && condition < 800) {
      return 'assets/animations/fog.json';
    } else if (condition == 800) {
      return 'assets/animations/sunny.json';
    } else {
      return 'assets/animations/cloudy.json';
    }
  }

  static String getWindDirection(double degree) {
    if (degree >= 337.5 || degree < 22.5) return 'N';
    if (degree >= 22.5 && degree < 67.5) return 'NE';
    if (degree >= 67.5 && degree < 112.5) return 'E';
    if (degree >= 112.5 && degree < 157.5) return 'SE';
    if (degree >= 157.5 && degree < 202.5) return 'S';
    if (degree >= 202.5 && degree < 247.5) return 'SW';
    if (degree >= 247.5 && degree < 292.5) return 'W';
    return 'NW';
  }

  static String getUvIndexLevel(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }
}