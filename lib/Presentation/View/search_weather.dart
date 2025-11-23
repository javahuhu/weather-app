import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Core/Themes/background_color.dart';
import 'package:weather_app/Data/DataSource/weather_datasource.dart';
import 'package:weather_app/Data/Models/weather_model.dart';

class SearchWeatherPage extends StatefulWidget {
  const SearchWeatherPage({super.key});

  @override
  State<SearchWeatherPage> createState() => _SearchWeatherPageState();
}

class _SearchWeatherPageState extends State<SearchWeatherPage>
    with TickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearching = false;
  bool _isFocused = false;

  final WeatherDatasource _weatherDatasource = WeatherDatasource();

  final Map<String, WeatherModel> _popularWeather = {};
  bool _isLoadingPopular = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });

    _fetchPopularCitiesWeather();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch() {
    final cityName = _cityController.text.trim();
    if (cityName.isEmpty) return;

    setState(() => _isSearching = true);
    HapticFeedback.mediumImpact();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() => _isSearching = false);

      context.push('/weather', extra: cityName);
    });
  }

  Future<void> _fetchPopularCitiesWeather() async {
    setState(() => _isLoadingPopular = true);

    final cities = ['London', 'Tokyo', 'New York', 'Dubai'];

    for (final city in cities) {
      try {
        final weather = await _weatherDatasource.getWeather(city);
        _popularWeather[city] = weather;
      } catch (_) {}
    }

    if (mounted) {
      setState(() => _isLoadingPopular = false);
    }
  }

  IconData _mapConditionToIcon(String condition, DateTime time) {
    final c = condition.toLowerCase();
    final hour = time.hour;
    final bool isNight = hour <= 5 || hour >= 18;

    if (c.contains('snow')) {
      return Icons.ac_unit_rounded;
    } else if (c.contains('rain') || c.contains('drizzle')) {
      return isNight ? Icons.thunderstorm_rounded : Icons.beach_access_rounded;
    } else if (c.contains('storm') || c.contains('thunder')) {
      return Icons.thunderstorm_rounded;
    } else if (c.contains('cloud')) {
      return isNight ? Icons.nights_stay_rounded : Icons.wb_cloudy_rounded;
    } else if (c.contains('clear')) {
      return isNight ? Icons.bedtime_rounded : Icons.wb_sunny_rounded;
    }

    return isNight ? Icons.dark_mode_rounded : Icons.wb_cloudy_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            _buildAnimatedBackground(),
            ..._buildFloatingOrbs(),
            ..._buildParticles(),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      _buildHeader(),
                      SizedBox(height: 40.h),
                      _buildGlobeAnimation(),
                      SizedBox(height: 25.h),
                      _buildTitleSection(),
                      SizedBox(height: 32.h),
                      _buildSearchSection(),
                      SizedBox(height: 24.h),
                      _buildSearchButton(),
                      SizedBox(height: 32.h),
                      _buildQuickCities(),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
          width: 1.sw,
          height: 1.sh,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [lightOrange, mediumOrange, primaryOrange, darkOrange],
              stops: [0.0, 0.3, 0.6, 1.0],
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          duration: 8000.ms,
          color: Colors.white.withValues(alpha: 0.08),
        );
  }

  List<Widget> _buildFloatingOrbs() {
    return [
      Positioned(
            top: -80.h,
            right: -60.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentYellow.withValues(alpha: 0.3),
                    accentYellow.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.15, 1.15),
            duration: 6000.ms,
          )
          .moveX(begin: 0, end: 20, duration: 6000.ms),

      Positioned(
            bottom: 80.h,
            left: -80.w,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 7000.ms,
          )
          .moveY(begin: 0, end: -30, duration: 7000.ms),

      Positioned(
            top: 300.h,
            right: 20.w,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    darkOrange.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: 0, end: 40, duration: 4000.ms)
          .fadeIn(duration: 2000.ms),
    ];
  }

  List<Widget> _buildParticles() {
    return List.generate(8, (i) {
      final positions = [
        [0.1, 0.2],
        [0.8, 0.15],
        [0.15, 0.5],
        [0.85, 0.45],
        [0.3, 0.7],
        [0.7, 0.75],
        [0.5, 0.3],
        [0.25, 0.85],
      ];
      final sizes = [8.0, 6.0, 10.0, 5.0, 7.0, 9.0, 6.0, 8.0];
      final delays = [0, 500, 1000, 1500, 2000, 2500, 3000, 3500];
      final colors = [
        Colors.white,
        accentYellow,
        Colors.white,
        cream,
        accentYellow,
        Colors.white,
        cream,
        accentYellow,
      ];

      return Positioned(
            left: positions[i][0].sw,
            top: positions[i][1].sh,
            child: Container(
              width: sizes[i].w,
              height: sizes[i].h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[i].withValues(alpha: 0.6),
                boxShadow: [
                  BoxShadow(
                    color: colors[i].withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          )
          .animate(delay: delays[i].ms, onPlay: (c) => c.repeat(reverse: true))
          .fadeIn(duration: 1500.ms)
          .moveY(
            begin: 0,
            end: (i.isEven ? 20 : -20).toDouble(),
            duration: (3000 + i * 300).ms,
          )
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(0.6, 0.6),
            duration: (2500 + i * 200).ms,
          );
    });
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: darkOrange.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.wb_sunny_rounded, color: darkOrange, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'WeatherNow',
                    style: TextStyle(
                      color: darkText,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
      ],
    );
  }

  Widget _buildGlobeAnimation() {
    return Stack(
          alignment: Alignment.center,
          children: [
            Container(
                  width: 260.w,
                  height: 260.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentYellow.withValues(alpha: 0.2),
                        lightOrange.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 3000.ms,
                ),

            Container(
                  width: 230.w,
                  height: 230.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.05, 1.05),
                  duration: 4000.ms,
                ),

            Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: darkOrange.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Lottie.asset(
                  'assets/lottie/pin-world.json',
                  width: 160.w,
                  height: 160.h,
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              ),
            ),

            SizedBox(
              width: 240.w,
              height: 240.h,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 2 * 3.14159),
                duration: const Duration(seconds: 10),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentYellow,
                          boxShadow: [
                            BoxShadow(
                              color: accentYellow.withValues(alpha: 0.8),
                              blurRadius: 12,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 1000.ms, delay: 300.ms)
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1, 1),
          curve: Curves.elasticOut,
          duration: 1200.ms,
        )
        .then()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -8, duration: 3000.ms);
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
              'Discover Weather',
              style: TextStyle(
                fontSize: 34.sp,
                fontWeight: FontWeight.w800,
                color: cream,
                letterSpacing: 0.5,
                height: 1.2,
                shadows: [
                  Shadow(
                    color: const Color.fromARGB(
                      255,
                      0,
                      0,
                      0,
                    ).withValues(alpha: 0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 500.ms)
            .slideY(begin: 0.3, end: 0),
        SizedBox(height: 12.h),
        Text(
              'Search any city worldwide and get\nreal-time weather updates instantly',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withValues(alpha: 0.75),
                height: 1.5,
                letterSpacing: 0.3,
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 700.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildSearchSection() {
    return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: accentYellow.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: _isFocused
                    ? darkOrange
                    : Colors.white.withValues(alpha: 0.7),
                width: _isFocused ? 2.5 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(
                    255,
                    0,
                    0,
                    0,
                  ).withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              controller: _cityController,
              focusNode: _focusNode,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: darkText,
              ),
              decoration: InputDecoration(
                hintText: 'Search for a city...',
                hintStyle: TextStyle(
                  color: darkText.withValues(alpha: 0.4),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 12.w),
                  child: Icon(
                    Icons.search_rounded,
                    color: _isFocused
                        ? darkOrange
                        : darkText.withValues(alpha: 0.4),
                    size: 26.sp,
                  ),
                ),
                suffixIcon: _cityController.text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: IconButton(
                          onPressed: () {
                            _cityController.clear();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: darkText.withValues(alpha: 0.5),
                            size: 22.sp,
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: 900.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildSearchButton() {
    final bool isActive = _cityController.text.trim().isNotEmpty;

    return GestureDetector(
          onTap: _isSearching ? null : _onSearch,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 60.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isActive
                    ? [
                        const Color.fromARGB(255, 0, 0, 0),
                        const Color.fromARGB(255, 0, 0, 0),
                      ]
                    : [
                        const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ).withValues(alpha: 0.3),
                        const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ).withValues(alpha: 0.4),
                      ],
              ),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: darkOrange.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: deepBrown.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: _isSearching
                  ? SizedBox(
                      width: 26.w,
                      height: 26.h,
                      child: CircularProgressIndicator(
                        color: cream,
                        strokeWidth: 3,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.explore_rounded, color: cream, size: 24.sp),
                        SizedBox(width: 12.w),
                        Text(
                          'Explore Weather',
                          style: TextStyle(
                            color: cream,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: 1100.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          duration: 3000.ms,
          color: Colors.white.withValues(alpha: 0.15),
          delay: 2000.ms,
        );
  }

  Widget _buildQuickCities() {
    final cities = ['London', 'Tokyo', 'New York', 'Dubai'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 2.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, darkText.withValues(alpha: 0.3)],
                ),
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Popular Cities',
              style: TextStyle(
                color: darkText.withValues(alpha: 0.7),
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 30.w,
              height: 2.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [darkText.withValues(alpha: 0.3), Colors.transparent],
                ),
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 1300.ms),
        SizedBox(height: 18.h),
        SizedBox(
          height: 110.h,
          child: _isLoadingPopular
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 4,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, _) => SizedBox(width: 12.w),
                  itemBuilder: (context, i) {
                    return Container(
                          height: 100.h,
                          width: 100.w,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 50.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                width: 30.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .shimmer(
                          duration: 2.seconds,
                          color: Colors.white.withValues(alpha: 0.4),
                        )
                        .fadeIn(duration: 400.ms, delay: (1300 + i * 80).ms)
                        .slideY(begin: 0.3, end: 0);
                  },
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: cities.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (_, _) => SizedBox(width: 12.w),
                  itemBuilder: (context, i) {
                    final name = cities[i];
                    final weather = _popularWeather[name];

                    final icon = weather != null
                        ? _mapConditionToIcon(
                            weather.condition,
                            weather.localdateTime,
                          )
                        : Icons.location_city_rounded;

                    final tempText = weather != null
                        ? '${weather.temperature.round()}°'
                        : '--°';

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _cityController.text = name;
                        setState(() {});
                      },
                      child:
                          Container(
                                height: 100.h,
                                width: 100.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkOrange.withValues(alpha: 0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(icon, color: darkOrange, size: 22.sp),
                                    SizedBox(height: 4.h),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        color: darkText,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      tempText,
                                      style: TextStyle(
                                        color: darkText.withValues(alpha: 0.6),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(
                                duration: 500.ms,
                                delay: (1400 + i * 100).ms,
                              )
                              .slideY(begin: 0.5, end: 0)
                              .then()
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .shimmer(
                                duration: 1.2.ms,
                                color: Colors.white.withValues(alpha: 0.4),
                              )
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.03, 1.03),
                                duration: (2000 + i * 200).ms,
                              ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
