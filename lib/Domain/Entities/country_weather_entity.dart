class CountryWeatherEntity {
  final String name;
  final String country;
  final String? state;
  final double lat;
  final double lon;

  CountryWeatherEntity({
    required this.name,
    required this.country,
    this.state,
    required this.lat,
    required this.lon,
  });

  CountryWeatherEntity copyWith({
    String? name,
    String? country,
    String? state,
    double? lat,
    double? lon,
  }) {
    return CountryWeatherEntity(
      name: name ?? this.name,
      country: country ?? this.country,
      state: state ?? this.state,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}
