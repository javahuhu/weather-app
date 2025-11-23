import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Core/Themes/background_color.dart';
import 'package:weather_app/Domain/Entities/hourly_weather_entity.dart';
import 'package:weather_app/Presentation/Bloc/weather_bloc.dart';
import 'package:weather_app/Presentation/Bloc/weather_state.dart';
import 'package:weather_app/Presentation/Utils/condition_background.dart';
import 'package:weather_app/Presentation/Utils/condition_decoration.dart';
import 'package:weather_app/Presentation/Utils/condition_title.dart';

class WeatherPageScreen extends StatefulWidget {
  final String cityName;
  const WeatherPageScreen({super.key, required this.cityName});

  @override
  State<WeatherPageScreen> createState() => _WeatherPageScreenState();
}

class _WeatherPageScreenState extends State<WeatherPageScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _hasScheduledErrorPop = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatHourLabel(int hour24) {
    final period = hour24 >= 12 ? "PM" : "AM";
    final h = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return "$h $period";
  }

  String _mapConditionToAsset(String condition, bool isNight) {
    final c = condition.toLowerCase();

    if (isNight) {
      return 'assets/images/night.png';
    }

    if (c.contains('snow')) {
      return 'assets/images/snowy.png';
    } else if (c.contains('rain') || c.contains('drizzle')) {
      return 'assets/images/rainy.png';
    } else if (c.contains('cloud')) {
      return 'assets/images/cloudy.png';
    } else if (c.contains('clear')) {
      return 'assets/images/sunny.png';
    }

    // fallback
    return 'assets/images/cloudy.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading || state is WeatherInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            final weather = state.weather;
            final hourlyForecast = state.hourly;
            return Stack(
              children: [
                _buildBackgroundGradient(
                  weather.condition,
                  weather.localdateTime,
                  weather.cloudiness,
                ),
                WeatherDecoration.buildConditionDecoration(
                  weather.condition,
                  weather.localdateTime,
                  weather.cloudiness,
                ),
                _buildBlurOverlay(),
                _buildCloudsAnimation(),
                _buildScrollableContent(
                  weather.condition,
                  weather.cityName,
                  weather.temperature,
                  weather.humidity,
                  weather.windSpeed,
                  weather.visibility,
                  weather.localdateTime,
                  weather.timzeZOne,
                  weather.cloudiness,
                  hourlyForecast,
                ),
              ],
            );
          } else if (state is WeatherError) {
            if (!_hasScheduledErrorPop) {
              _hasScheduledErrorPop = true;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Future.delayed(const Duration(seconds: 3), () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                });
              });
            }

            return Scaffold(
              
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [lightOrange, mediumOrange, primaryOrange, darkOrange],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 80.h,
                        left: 24.w,
                        right: 24.w,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 14.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 1.2,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.16),
                                  Colors.white.withValues(alpha: 0.06),
                                ],
                              ),
                             
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                  child: const Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    state.message.replaceFirst(
                                      'Exception: ',
                                      '',
                                    ), // cleaner
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }

  Widget _buildBackgroundGradient(
    String condition,
    DateTime datetime,
    int cloudiness,
  ) {
    return WeatherBackground.mapConditionBackground(
      condition,
      datetime,
      cloudiness,
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildCloudsAnimation() {
    return Positioned(
      top: -190.h,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: 0.2,
        child: SizedBox(
          height: 625.h,
          child: Lottie.asset(
            'assets/lottie/clouds.json',
            fit: BoxFit.cover,
            controller: _animationController,
            onLoaded: (composition) {
              _animationController
                ..duration = composition.duration * 2
                ..repeat();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent(
    String condition,
    String cityName,
    double temperature,
    int humidity,
    double windSpeed,
    int visibility,
    DateTime localdateTime,
    int timeZone,
    int cloudiness,
    List<HourlyWeatherEntity> hourlyForecast,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeText(localdateTime),
          _buildCityName(cityName),
          _buildHeaderDivider(),
          _buildDateText(localdateTime),
          _buildTemperature(temperature),
          _buildWeatherDescription(condition, localdateTime, cloudiness),
          _buildHourlyForecastCard(hourlyForecast),
          _buildGridContainer(temperature, humidity, windSpeed, visibility),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildTimeText(DateTime localdateTime) {
    final hh = localdateTime.hour.toString().padLeft(2, '0');
    final mm = localdateTime.minute.toString().padLeft(2, '0');
    return Padding(
      padding: EdgeInsets.only(top: 50.h, left: 15.w),
      child: Text(
        "$hh:$mm",
        style: GoogleFonts.poppins(
          fontSize: 22.sp,
          color: const Color.fromARGB(255, 255, 255, 255),
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              offset: const Offset(2, 3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityName(String cityName) {
    return Padding(
      padding: EdgeInsets.only(top: 0.h, left: 15.w),
      child: Text(
        cityName,
        style: GoogleFonts.poppins(
          fontSize: 45.sp,
          color: const Color.fromARGB(255, 255, 255, 255),
          height: 0.9,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.4),
              offset: const Offset(2, 3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDivider() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, left: 15.w, right: 190.w),
      child: Divider(
        color: Colors.white.withValues(alpha: 0.7),
        thickness: 3.h,
      ),
    );
  }

  Widget _buildDateText(DateTime localdateTime) {
    final d = localdateTime.day.toString().padLeft(2, '0');
    final m = localdateTime.month.toString().padLeft(2, '0');
    final y = (localdateTime.year % 100).toString().padLeft(2, '0');
    return Padding(
      padding: EdgeInsets.only(top: 0.h, left: 15.w),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Today ",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: const Color.fromARGB(
                  255,
                  68,
                  68,
                  68,
                ).withValues(alpha: 0.5),
                height: 1,
              ),
            ),
            TextSpan(
              text: "$d.$m.$y",
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.white,
                height: 1,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    offset: const Offset(2, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperature(double temperature) {
    return Padding(
      padding: EdgeInsets.only(top: 70.h),
      child: Center(
        child: Text(
          "${temperature.toStringAsFixed(0)}°",
          style: GoogleFonts.poppins(
            fontSize: 90.sp,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w500,
            height: 1,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.4),
                offset: const Offset(2, 3),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDescription(
    String condition,
    DateTime localdateTime,
    int cloudiness,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Center(
        child: WeatherTitle.mapConditionTitle(
          condition,
          localdateTime,
          cloudiness,
        ),
      ),
    );
  }

  Widget _buildHourlyForecastCard(List<HourlyWeatherEntity> hourly) {
    return Padding(
      padding: EdgeInsets.only(top: 70.h, left: 20.w, right: 20.w),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.white.withValues(alpha: 0.45),
              thickness: 3.h,
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 120.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (_, _) => SizedBox(width: 25.w),
                itemCount: hourly.length,
                itemBuilder: (context, index) {
                  final h = hourly[index];
                  final hourLabel = _formatHourLabel(h.dateTime.hour);
                  final isNight = h.dateTime.hour <= 5 || h.dateTime.hour >= 18;
                  final iconPath = _mapConditionToAsset(h.condition, isNight);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hourLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: const Offset(2, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Image.asset(
                        iconPath,
                        height: 40.h,
                        width: 40.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "${h.temperature.toStringAsFixed(0)}°",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: const Offset(2, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 5.h),
            Divider(
              color: Colors.white.withValues(alpha: 0.45),
              thickness: 3.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridContainer(
    double temperature,
    int humidity,
    double windSpeed,
    int visibility,
  ) {
    final List<Map<String, dynamic>> weatherMetrics = [
      {'icon': Icons.water_drop, 'label': 'Humidity', 'value': '$humidity%'},
      {
        'icon': Icons.air,
        'label': 'Wind Speed',
        'value': '${windSpeed.toStringAsFixed(1)} m/s',
      },
      {
        'icon': Icons.thermostat,
        'label': 'Feels Like',
        'value': "${temperature.toStringAsFixed(0)}°",
      },
      {
        'icon': Icons.visibility,
        'label': 'Visibility',
        'value': "${visibility.toStringAsFixed(0)}KM",
      },
    ];

    return Padding(
      padding: EdgeInsets.only(top: 30.h, left: 20.w, right: 20.w),
      child: SizedBox(
        height: 370.h,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20.h,
            crossAxisSpacing: 20.w,
            childAspectRatio: 1,
          ),
          itemCount: weatherMetrics.length,
          itemBuilder: (context, index) {
            final weather = weatherMetrics[index];
            return Container(
              height: 100.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  0,
                  0,
                  0,
                ).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20.r),
              ),

              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(weather['icon'], color: Colors.white, size: 40.sp),
                  SizedBox(height: 10.h),
                  Text(
                    weather['label'],
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          offset: const Offset(2, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    weather['value'],
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          offset: const Offset(2, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
