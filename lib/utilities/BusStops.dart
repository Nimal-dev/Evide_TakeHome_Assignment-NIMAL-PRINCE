class BusStop {
  final String stopname;
  final double latitude;
  final double longitude;
  final int timedifference;

  BusStop({
    required this.stopname,
    required this.latitude,
    required this.longitude,
    required this.timedifference,
  });

  /// Create a BusStop object from JSON
  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      stopname: json['stopname'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timedifference: (json['timedifference'] as num).toInt(),
    );
  }
}
