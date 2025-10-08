import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const WeatherIcon({
    Key? key,
    required this.iconCode,
    this.size = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://openweathermap.org/img/wn/$iconCode@2x.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}