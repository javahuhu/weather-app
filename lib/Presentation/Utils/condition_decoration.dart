import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherDecoration {
  static Widget buildConditionDecoration(
    String condition,
    DateTime datetime,
    int cloudiness,
  ) {
    final c = condition.toLowerCase();
    final hour = datetime.hour;

    final bool isNight = hour <= 5 || hour >= 18;
    final bool isClearOrSlight = cloudiness <= 60;
    final bool isHeavyCloud = cloudiness > 60;

    final bool isFogLike =
        c.contains('mist') || c.contains('fog') || c.contains('haze');

    final bool isRainy =
        c.contains('rain') || c.contains('shower') || c.contains('drizzle');

    final bool isSnowy =
        c.contains('snow') || c.contains('sleet') || c.contains('flurry');

    // NIGHTTIME DECORATIONS
    if (isNight) {
      if (isSnowy) return _buildSnowyDecoration();
      if (isRainy) return _buildRainyDecoration();
      if (isClearOrSlight) return _buildClearNightDecoration();
      if (isHeavyCloud || isFogLike) return _buildCloudyDecoration();
      return _buildClearNightDecoration();
    }

    // DAYTIME DECORATIONS
    if (isSnowy) {
      return _buildSnowyDecoration();
    } else if (isRainy) {
      return _buildRainyDecoration();
    } else if (isClearOrSlight) {
      return _buildClearSunDecoration();
    } else if (isHeavyCloud || isFogLike) {
      return _buildCloudyDecoration();
    }

    return const SizedBox.shrink();
  }

  static Widget _buildClearSunDecoration() {
    return Positioned(
      top: -80.h,
      left: 170.w,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: SizedBox(
          height: 300.h,
          width: 300.w,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 260.w,
                  height: 260.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFCC70).withValues(alpha: 1),
                      width: 8.w,
                    ),
                  ),
                ),
                Container(
                  width: 180.w,
                  height: 180.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 255, 186, 59),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildCloudyDecoration() {
    return Positioned(
      top: 300.h,
      left: 125.w,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 200.h,
          width: 300.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(110.w),
          ),
        ),
      ),
    );
  }

  static Widget _buildRainyDecoration() {
    return Positioned(
      top: 300.h,
      left: 125.w,
      child: Opacity(
        opacity: 0.2,
        child: Image.asset(
          'assets/images/rainy.png',
          height: 250.h,
          width: 300.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  static Widget _buildSnowyDecoration() {
    return Positioned(
      top: 300.h,
      left: 125.w,
      child: Opacity(
        opacity: 0.2,
        child: Image.asset(
          'assets/images/snowy.png',
          height: 200.h,
          width: 300.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  static Widget _buildClearNightDecoration() {
    return Positioned(
      top: -80.h,
      left: 170.w,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: SizedBox(
          height: 300.h,
          width: 300.w,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300.w,
                  height: 300.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF6F3E9).withValues(alpha: 0.35),
                      width: 4.w,
                    ),
                  ),
                ),
                Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF6F3E9).withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
