import 'package:weather_app/Domain/Entities/hourly_weather_entity.dart';

class HourlyWeatherModel extends HourlyWeatherEntity {
  HourlyWeatherModel({
    required super.dateTime,
    required super.temperature,
    required super.condition,
    required super.description,
    required super.humidity,
    required super.windSpeed,
    required super.visibility,
    required super.cloudiness,
  });

  factory HourlyWeatherModel.fromJson(
    Map<String, dynamic> json,
    int timezoneOffset,
  ) {
    final int dt = json['dt'] as int;

    final DateTime utcTime = DateTime.fromMillisecondsSinceEpoch(
      dt * 1000,
      isUtc: true,
    );
    final DateTime localTime = utcTime.add(Duration(seconds: timezoneOffset));

    final main = json['main'] as Map<String, dynamic>;
    final weatherList = json['weather'] as List;
    final weather0 = weatherList.isNotEmpty
        ? weatherList.first as Map<String, dynamic>
        : <String, dynamic>{};
    final wind = (json['wind'] as Map<String, dynamic>?) ?? {};
    final clouds = (json['clouds'] as Map<String, dynamic>?) ?? {};

    return HourlyWeatherModel(
      dateTime: localTime,
      temperature: (main['temp'] as num).toDouble(),
      condition: (weather0['main'] as String?) ?? '',
      description: (weather0['description'] as String?) ?? '',
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      cloudiness: (clouds['all'] as num?)?.toInt() ?? 0,
    );
  }
}
