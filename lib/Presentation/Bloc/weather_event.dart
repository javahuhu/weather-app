import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWeatherLocation extends WeatherEvent {
  final String cityName;

  FetchWeatherLocation({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}
