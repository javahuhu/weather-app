import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/Data/Repositories/repositories_abstract/weather_repositories_abstract.dart';
import 'package:weather_app/Presentation/Bloc/weather_event.dart';
import 'package:weather_app/Presentation/Bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepositoriesAbstract repository;

  WeatherBloc({required this.repository}) : super(WeatherInitial()) {
    on<FetchWeatherLocation>(_onFetchWeatherLocation);
  }

  Future<void> _onFetchWeatherLocation(
    FetchWeatherLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      final weather = await repository.getWeatherLocation(
        cityName: event.cityName,
      );

      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
}
