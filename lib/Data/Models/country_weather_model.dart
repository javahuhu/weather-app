import 'package:weather_app/Domain/Entities/country_weather_entity.dart';

class CountryWeatherModel extends CountryWeatherEntity {
  CountryWeatherModel({
    required super.name,
    required super.country,
    required super.state,
    required super.lat,
    required super.lon,
  });

  factory CountryWeatherModel.fromJson(Map<String, dynamic> json) {
    return CountryWeatherModel(
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
      state: json['state'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  String get displayCountry {
    if (state != null && state!.isEmpty) {
      return '$name, $country, $state';
    }

    return '$name, $country';
  }
}
