class WeatherEntity {
  final String cityName;
  final String condition;
  final double temperature;
  final String description;
  final double humidity;
  final double windSpeed;

  WeatherEntity({
    required this.cityName,
    required this.condition,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });
}
