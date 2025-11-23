class HourlyWeatherEntity {
  final DateTime dateTime;      
  final double temperature;     
  final String condition;       
  final String description;     
  final int humidity;           
  final double windSpeed;       
  final int visibility;         
  final int cloudiness;         

  HourlyWeatherEntity({
    required this.dateTime,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.cloudiness,
  });
}
