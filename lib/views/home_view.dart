import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_now/views/weather_detail_view.dart';
import '../providers/weather_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/weather_icon.dart';
import '../widgets/weather_card.dart';
import '../widgets/daily_forecast_card.dart';
import '../utils/constants.dart';
import 'location_search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchCurrentLocationWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Weather Now',
              style: AppTextStyles.heading2,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationSearchView(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: weatherProvider.fetchCurrentLocationWeather,
              ),
            ],
          ),
          body: Stack(
            children: [
              if (weatherProvider.currentWeather != null)
                AnimatedBackground(
                  condition: weatherProvider.currentWeather!.condition,
                  isDay: true,
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: weatherProvider.isLoading
                      ? const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50,
                    ),
                  )
                      : weatherProvider.currentWeather != null
                      ? _buildWeatherContent(weatherProvider)
                      : _buildErrorContent(weatherProvider),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeatherContent(WeatherProvider weatherProvider) {
    final weather = weatherProvider.currentWeather!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          // Location and Temperature - Make it tappable
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherDetailView(weather: weather),
                ),
              );
            },
            child: Center(
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tap for details',
                        style: AppTextStyles.subtitle,
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white54),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Weather Details Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              WeatherCard(
                title: 'Feels Like',
                value: weather.feelsLike.round().toString(),
                unit: '°',
                icon: Icons.thermostat,
              ),
              WeatherCard(
                title: 'Humidity',
                value: weather.humidity.toString(),
                unit: '%',
                icon: Icons.water_drop,
              ),
              WeatherCard(
                title: 'Wind Speed',
                value: weather.windSpeed.round().toString(),
                unit: ' m/s',
                icon: Icons.air,
              ),
              WeatherCard(
                title: 'Pressure',
                value: '1013',
                unit: ' hPa',
                icon: Icons.compress,
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Daily Forecast
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5-Day Forecast',
                style: AppTextStyles.heading2,
              ),
              Text(
                'See More',
                style: AppTextStyles.body.copyWith(color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...weatherProvider.dailyForecast.take(5).map(
                (forecast) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DailyForecastCard(forecast: forecast),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(WeatherProvider weatherProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          Text(
            weatherProvider.error.isNotEmpty
                ? weatherProvider.error
                : 'Unable to load weather data',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: weatherProvider.fetchCurrentLocationWeather,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}