import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherTitle {
  static Widget mapConditionTitle(
    String condition,
    DateTime time,
    int cloudiness,
  ) {
    final c = condition.toLowerCase();
    final hour = time.hour;
    final bool isNight = hour <= 5 || hour >= 18;

    final bool isClearOrSlight = cloudiness <= 60;
    final bool isHeavyCloud = cloudiness > 60;
    final bool isFogLike =
        c.contains('mist') || c.contains('fog') || c.contains('haze');

    Text texts(String value) {
      return Text(
        value,
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
      );
    }

    if (c.contains('snow')) {
      return texts("It's Snowy Outside");
    }

    if (c.contains('rain') || c.contains('drizzle')) {
      return texts("It's Raining Outside");
    }

    if (c.contains('storm') || c.contains('thunder')) {
      return texts("Careful of Thunderstorms");
    }

    if (isFogLike) {
      return texts("It's Foggy Outside");
    }

    if (isHeavyCloud) {
      if (cloudiness >= 70) {
        return texts("It's Cloudy Outside");
      }
    }

    if (isClearOrSlight || c.contains('clear')) {
      return isNight
          ? texts("It's Clear Night Outside")
          : texts("It's Clear Sunny Outside");
    }

    return isNight
        ? texts("It's Clear Night Outside")
        : texts("It's Clear Sunny Outside");
  }
}
