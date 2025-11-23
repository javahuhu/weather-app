import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/Data/DataSource/weather_datasource.dart';
import 'package:weather_app/Data/Repositories/repositories_implementation/weather_repositories_implementation.dart';
import 'package:weather_app/Presentation/Bloc/weather_bloc.dart';
import 'package:weather_app/Presentation/Bloc/weather_event.dart';
import 'package:weather_app/Presentation/View/splashscreen.dart';
import 'package:weather_app/Presentation/View/getstarted.dart';
import 'package:weather_app/Presentation/View/search_weather.dart';
import 'package:weather_app/Presentation/View/weather.dart';
// <-- your target page

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const Splashscreen(),
    ),

    GoRoute(
      path: '/getstarted',
      name: 'getstarted',
      builder: (context, state) {
        return const GetStartedPage();
      },
    ),

    GoRoute(
      path: '/saerchweather',
      name: 'searchweather',
      builder: (context, state) {
        return const SearchWeatherPage();
      },
    ),

    GoRoute(
      path: '/weather',
      name: 'weather',
      builder: (context, state) {
        final cityName = state.extra as String;

        return BlocProvider(
          create: (_) {
            final datasource = WeatherDatasource();
            final repo = WeatherRepositoriesImplementation(
              weatherDatasource: datasource,
            );

           
            return WeatherBloc(repository: repo)
              ..add(FetchWeatherLocation(cityName: cityName));
          },
          child: WeatherPageScreen(cityName: cityName),
        );
      },
    ),
  ],
);
