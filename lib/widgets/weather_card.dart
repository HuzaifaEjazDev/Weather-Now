import 'package:flutter/material.dart';
import '../utils/constants.dart';

class WeatherCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;

  const WeatherCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: 4),
            Text(
              '$value$unit',
              style: AppTextStyles.heading2,
            ),
          ],
        ),
      ),
    );
  }
}