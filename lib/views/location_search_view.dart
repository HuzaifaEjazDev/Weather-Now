import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/weather_service.dart';
import '../models/location_model.dart';

class LocationSearchView extends StatefulWidget {
  const LocationSearchView({Key? key}) : super(key: key);

  @override
  State<LocationSearchView> createState() => _LocationSearchViewState();
}

class _LocationSearchViewState extends State<LocationSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  List<Location> _searchResults = [];
  bool _isSearching = false;

  void _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _weatherService.searchLocation(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _selectLocation(Location location) async {
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.fetchWeatherByLocation(location.lat, location.lon);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search for a city...',
            border: InputBorder.none,
          ),
          onChanged: _searchLocation,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _searchLocation('');
              },
            ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
          ? const Center(
        child: Text('Search for a city to see results'),
      )
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final location = _searchResults[index];
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(location.name),
            subtitle: Text(location.country),
            onTap: () => _selectLocation(location),
          );
        },
      ),
    );
  }
}