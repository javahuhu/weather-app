class WeatherEntity {
  final String cityName;
  final String condition;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int visibility;
  final DateTime localdateTime;
  final int timzeZOne;
  final int cloudiness;

  WeatherEntity({
    required this.cityName,
    required this.condition,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.localdateTime,
    required this.timzeZOne,
    required this.cloudiness,
  });
}
