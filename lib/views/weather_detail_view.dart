import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/weather_model.dart';
import '../utils/constants.dart';
import '../widgets/animated_background.dart';
import '../widgets/weather_icon.dart';

class WeatherDetailView extends StatelessWidget {
  final WeatherData weather;

  const WeatherDetailView({
    Key? key,
    required this.weather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Weather Details',
          style: AppTextStyles.heading2,
        ),
      ),
      body: Stack(
        children: [
          AnimatedBackground(
            condition: weather.condition,
            isDay: true,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  // Header Section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          weather.location,
                          style: AppTextStyles.heading1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          weather.description,
                          style: AppTextStyles.body,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WeatherIcon(iconCode: weather.icon, size: 80),
                            Text(
                              '${weather.temperature.round()}°',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Feels like ${weather.feelsLike.round()}°',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Detailed Weather Information
                  Expanded(
                    child: ListView(
                      children: [
                        _buildDetailCard(
                          icon: Icons.thermostat,
                          title: 'Temperature Details',
                          children: [
                            _buildDetailItem('Current', '${weather.temperature.round()}°C'),
                            _buildDetailItem('Feels Like', '${weather.feelsLike.round()}°C'),
                            _buildDetailItem('Min/Max', '${(weather.temperature - 5).round()}° / ${(weather.temperature + 5).round()}°'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailCard(
                          icon: Icons.water_drop,
                          title: 'Humidity & Pressure',
                          children: [
                            _buildDetailItem('Humidity', '${weather.humidity}%'),
                            _buildDetailItem('Dew Point', '${(weather.temperature - (100 - weather.humidity) / 5).round()}°C'),
                            _buildDetailItem('Pressure', '1013 hPa'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailCard(
                          icon: Icons.air,
                          title: 'Wind & Visibility',
                          children: [
                            _buildDetailItem('Wind Speed', '${weather.windSpeed} m/s'),
                            _buildDetailItem('Wind Direction', 'North'),
                            _buildDetailItem('Visibility', '10 km'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailCard(
                          icon: Icons.wb_sunny,
                          title: 'Sun & Moon',
                          children: [
                            _buildDetailItem('Sunrise', '6:45 AM'),
                            _buildDetailItem('Sunset', '6:30 PM'),
                            _buildDetailItem('UV Index', '3 (Moderate)'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailCard(
                          icon: Icons.analytics,
                          title: 'Additional Information',
                          children: [
                            _buildDetailItem('Cloud Cover', '${weather.condition == 800 ? 0 : 75}%'),
                            _buildDetailItem('Precipitation', '0%'),
                            _buildDetailItem('Humidity Index', _calculateHumidityIndex(weather.humidity)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyles.heading2,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(color: Colors.white70),
          ),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateHumidityIndex(int humidity) {
    if (humidity < 30) return 'Dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 80) return 'Moderate';
    return 'High';
  }
}