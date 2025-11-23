import 'package:weather_app/Domain/Entities/weather_entity.dart';

abstract class WeatherRepositoriesAbstract {
  Future<WeatherEntity> getWeatherLocation({
    required String cityName,
    
  });
}
