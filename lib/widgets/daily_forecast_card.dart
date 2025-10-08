import 'package:flutter/material.dart';
import 'package:weather_now/widgets/weather_icon.dart';

import '../models/weather_model.dart';
import '../utils/constants.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyForecast forecast;

  const DailyForecastCard({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  String _getWeekday(DateTime date) {
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                _getWeekday(forecast.date),
                style: AppTextStyles.heading2,
              ),
            ),
            Expanded(
              flex: 3,
              child: WeatherIcon(iconCode: forecast.icon, size: 40),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${forecast.maxTemp.round()}°',
                    style: AppTextStyles.heading2,
                  ),
                  Text(
                    '${forecast.minTemp.round()}°',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}