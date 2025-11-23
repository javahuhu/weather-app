import 'package:equatable/equatable.dart';
import 'package:weather_app/Domain/Entities/hourly_weather_entity.dart';
import 'package:weather_app/Domain/Entities/weather_entity.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;
  final List<HourlyWeatherEntity> hourly;

  const WeatherLoaded({required this.weather, required this.hourly});

  @override
  List<Object?> get props => [weather, hourly];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message});

  @override
  List<Object?> get props => [message];
}
