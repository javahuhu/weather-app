import 'package:weather_app/Data/DataSource/weather_datasource.dart';
import 'package:weather_app/Data/Models/weather_model.dart';
import 'package:weather_app/Data/Repositories/repositories_abstract/weather_repositories_abstract.dart';
import 'package:weather_app/Domain/Entities/hourly_weather_entity.dart';
import 'package:weather_app/Domain/Entities/weather_entity.dart';

class WeatherRepositoriesImplementation extends WeatherRepositoriesAbstract {
  final WeatherDatasource weatherDatasource;

  WeatherRepositoriesImplementation({required this.weatherDatasource});

  @override
  Future<WeatherEntity> getWeatherLocation({required String cityName}) async {
    final WeatherModel wModel = await weatherDatasource.getWeather(cityName);

    return wModel;
  }

  @override
  Future<List<HourlyWeatherEntity>> getHourlyForecast({
    required String cityName,
  }) async {
    final hmodel = await weatherDatasource.getForecast(cityName);
    return hmodel;
  }
}
