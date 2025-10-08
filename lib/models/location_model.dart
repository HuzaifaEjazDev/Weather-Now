class Location {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String region;

  Location({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    required this.region,
  });

  factory Location.fromWeatherApiJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
      country: json['country'] ?? '',
      region: json['region'] ?? '',
    );
  }

  // For OpenWeatherMap fallback
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
      country: json['country'] ?? '',
      region: json['state'] ?? '',
    );
  }
}