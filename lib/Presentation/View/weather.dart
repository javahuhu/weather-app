import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WeatherPageScreen extends StatefulWidget {
  final String cityName;
  const WeatherPageScreen({super.key, required this.cityName});

  @override
  State<WeatherPageScreen> createState() => _WeatherPageScreenState();
}

class _WeatherPageScreenState extends State<WeatherPageScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundGradient(),
          _buildBlurOverlay(),
          _buildCloudsAnimation(),
          _buildScrollableContent(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE9F3FF), // icy white-blue
            Color(0xFFCFE4FF), // soft frost blue
            Color(0xFFB9D6FF), // cold pastel blue
            Color(0xFFA9C8FF), // deeper snow sky
          ],
        ),
      ),
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

  Widget _buildTimeText() {
    return Padding(
      padding: EdgeInsets.only(top: 50.h, left: 15.w),
      child: Text(
        "21:03",
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

  Widget _buildCityName() {
    return Padding(
      padding: EdgeInsets.only(top: 0.h, left: 15.w),
      child: Text(
        widget.cityName,
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

  Widget _buildDateText() {
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
              text: "28.12.25",
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

  Widget _buildTemperature() {
    return Padding(
      padding: EdgeInsets.only(top: 70.h),
      child: Center(
        child: Text(
          "26°",
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

  Widget _buildWeatherDescription() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Center(
        child: Text(
          "It's Sunny Outside",
          style: GoogleFonts.poppins(
            fontSize: 19.sp,
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
      ),
    );
  }

  Widget _buildHourlyForecastCard() {
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
                separatorBuilder: (_, __) => SizedBox(width: 25.w),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "12 PM",
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
                        "assets/images/cloudy.png",
                        height: 40.h,
                        width: 40.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "25°",
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

  Widget _buildGridContainer() {
    final List<Map<String, dynamic>> weatherMetrics = [
      {'icon': Icons.water_drop, 'label': 'Humidity', 'value': '60%'},
      {'icon': Icons.air, 'label': 'Wind Speed', 'value': '15 km/h'},
      {'icon': Icons.thermostat, 'label': 'Feels Like', 'value': '27°'},
      {'icon': Icons.visibility, 'label': 'Visibility', 'value': '10 km'},
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

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeText(),
          _buildCityName(),
          _buildHeaderDivider(),
          _buildDateText(),
          _buildTemperature(),
          _buildWeatherDescription(),
          _buildHourlyForecastCard(),
          _buildGridContainer(),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
