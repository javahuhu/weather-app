import 'package:weather_app/Domain/Entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required super.cityName,
    required super.condition,
    required super.temperature,
    required super.description,
    required super.humidity,
    required super.windSpeed,
    required super.localdateTime,
    required super.timzeZOne,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final int dt = json['dt'] as int;
    final int timeZone = json['timezone'] as int;

    final DateTime utcTime = DateTime.fromMillisecondsSinceEpoch(
      dt * 1000,
      isUtc: true,
    );
    final DateTime localTime = utcTime.add(Duration(seconds: timeZone));

    return WeatherModel(
      cityName: json['name'] as String,
      condition: (json['weather'] as List).first['main'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      humidity: (json['main']['humidity'] as num).toInt(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      localdateTime: localTime,
      timzeZOne: timeZone,
    );
  }
}
