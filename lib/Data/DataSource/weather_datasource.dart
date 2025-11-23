import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/Data/Models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherDatasource {
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<WeatherModel> getWeather(String cityName) async {
    final uri = Uri.parse("$baseUrl?q=$cityName&appid=$apiKey&units=metric");

    try {
      final response = await http.get(uri);

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
}
