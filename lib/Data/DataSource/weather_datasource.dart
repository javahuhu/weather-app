import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/Data/Models/hourly_weather_model.dart';
import 'package:weather_app/Data/Models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherDatasource {
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String baseUrlForecast =
      "https://api.openweathermap.org/data/2.5/forecast";
  final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<WeatherModel> getWeather(String cityName) async {
    final uri = Uri.parse("$baseUrl?q=$cityName&appid=$apiKey&units=metric");

    try {
      final response = await http.get(uri);
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception("City not found");
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather data: $e");
    }
  }

  Future<List<HourlyWeatherModel>> getForecast(String cityName) async {
    final uri = Uri.parse(
      "$baseUrlForecast?q=$cityName&appid=$apiKey&units=metric",
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;

        final int timezoneOffset =
            (data['city']?['timezone'] as num?)?.toInt() ?? 0;

        final List rawList = data['list'] as List;

        final List sliced = rawList.take(8).toList();

        return sliced
            .map(
              (e) => HourlyWeatherModel.fromJson(
                e as Map<String, dynamic>,
                timezoneOffset,
              ),
            )
            .toList();
      } else {
        throw Exception("Failed to load forecast data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching forecast data: $e");
    }
  }
}
