import 'package:flutter/material.dart';

class WeatherBackground {
  static Widget mapConditionBackground(
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

    if (c.contains('snow')) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE9F3FF),
              Color(0xFFCFE4FF),
              Color(0xFFB9D6FF),
              Color(0xFFA9C8FF),
            ],
          ),
        ),
      );
    }

    if (c.contains('rain') || c.contains('drizzle')) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A6B7A),
              Color(0xFF4C5D6C),
              Color(0xFF3C4C59),
              Color(0xFF2E3A45),
            ],
          ),
        ),
      );
    }

    if (c.contains('storm') || c.contains('thunder')) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A6B7A),
              Color(0xFF4C5D6C),
              Color(0xFF3C4C59),
              Color(0xFF2E3A45),
            ],
          ),
        ),
      );
    }

    if (isFogLike || isHeavyCloud) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD4D9DE),
              Color(0xFFB4BDC4),
              Color(0xFF8E9AA4),
              Color(0xFF707C86),
            ],
          ),
        ),
      );
    }

    if (isClearOrSlight || c.contains('clear')) {
      return isNight
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D1B2A),
                    Color(0xFF1B263B),
                    Color(0xFF274156),
                    Color(0xFF415A77),
                  ],
                ),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE0F2FF),
                    Color(0xFFB8E1FF),
                    Color(0xFF8DCBFF),
                    Color(0xFF64B5FF),
                  ],
                ),
              ),
            );
    }

    return isNight
        ? Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D1B2A),
                  Color(0xFF1B263B),
                  Color(0xFF274156),
                  Color(0xFF415A77),
                ],
              ),
            ),
          )
        : Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0F2FF),
                  Color(0xFFB8E1FF),
                  Color(0xFF8DCBFF),
                  Color(0xFF64B5FF),
                ],
              ),
            ),
          );
  }
}
