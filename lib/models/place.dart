class Place {
  final String id;
  String name;
  double? latitude;
  double? longitude;

  Place({required this.id, required this.name, this.latitude, this.longitude});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  String get coordinates {
    if (latitude != null && longitude != null) {
      return '$latitude,$longitude';
    }
    return '';
  }
}
