import 'package:weather_app/Domain/Entities/hourly_weather_entity.dart';
import 'package:weather_app/Domain/Entities/weather_entity.dart';

abstract class WeatherRepositoriesAbstract {
  Future<WeatherEntity> getWeatherLocation({required String cityName});

  Future<List<HourlyWeatherEntity>> getHourlyForecast({
    required String cityName,
  });
}
