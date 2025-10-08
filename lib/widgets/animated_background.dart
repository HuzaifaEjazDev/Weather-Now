import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedBackground extends StatelessWidget {
  final int condition;
  final bool isDay;

  const AnimatedBackground({
    Key? key,
    required this.condition,
    required this.isDay,
  }) : super(key: key);

  String _getAnimationUrl() {
    // Thunderstorm (200-299)
    if (condition >= 200 && condition < 300) {
      return 'https://assets2.lottiefiles.com/packages/lf20_u25cckyh.json';
    }
    // Rain/Drizzle (300-599)
    else if (condition >= 300 && condition < 600) {
      return 'https://assets2.lottiefiles.com/packages/lf20_kkflmtjr.json';
    }
    // Snow (600-699)
    else if (condition >= 600 && condition < 700) {
      return 'https://assets2.lottiefiles.com/packages/lf20_6xf0jier.json';
    }
    // Atmosphere - Fog/Mist (700-799)
    else if (condition >= 700 && condition < 800) {
      return 'https://assets2.lottiefiles.com/packages/lf20_ysrnmpwt.json';
    }
    // Clear (800)
    else if (condition == 800) {
      return isDay
          ? 'https://assets2.lottiefiles.com/packages/lf20_8vufs28q.json' // Sunny
          : 'https://assets2.lottiefiles.com/packages/lf20_ia6dsu6w.json'; // Night
    }
    // Clouds (801-804)
    else {
      return 'https://assets2.lottiefiles.com/packages/lf20_1pxe1jsx.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Lottie.network(
        _getAnimationUrl(),
        fit: BoxFit.cover,
        repeat: true,
        animate: true,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to gradient background if animation fails to load
          return _buildFallbackBackground();
        },
      ),
    );
  }

  Widget _buildFallbackBackground() {
    List<Color> colors = _getGradientColors();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
    );
  }

  List<Color> _getGradientColors() {
    if (condition >= 200 && condition < 300) {
      return [const Color(0xFF2C3E50), const Color(0xFF4CA1AF)]; // Storm
    } else if (condition >= 300 && condition < 600) {
      return [const Color(0xFF373B44), const Color(0xFF4286f4)]; // Rain
    } else if (condition >= 600 && condition < 700) {
      return [const Color(0xFFE6DADA), const Color(0xFF274046)]; // Snow
    } else if (condition >= 700 && condition < 800) {
      return [const Color(0xFF606c88), const Color(0xFF3f4c6b)]; // Fog
    } else if (condition == 800) {
      return isDay
          ? [const Color(0xFF56CCF2), const Color(0xFF2F80ED)] // Sunny
          : [const Color(0xFF0F2027), const Color(0xFF203A43)]; // Night
    } else {
      return [const Color(0xFFBBD2C5), const Color(0xFF536976)]; // Cloudy
    }
  }
}