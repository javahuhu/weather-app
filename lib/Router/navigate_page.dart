import 'package:go_router/go_router.dart';
import 'package:weather_app/Presentation/View/splashscreen.dart';
import 'package:weather_app/Presentation/View/getstarted.dart';
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
      path: '/weather',
      name: 'weather',
      builder: (context, state) {
        return const WeatherPage();
      },
    ),
  ],
);
