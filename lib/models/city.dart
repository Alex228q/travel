import 'package:travel/models/place.dart';

class City {
  final String id;
  String name;
  final List<Place> places;

  City({required this.id, required this.name, List<Place>? places})
    : places = places ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'places': places.map((place) => place.toJson()).toList(),
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      places: (json['places'] as List)
          .map((placeJson) => Place.fromJson(placeJson))
          .toList(),
    );
  }

  void addPlace(Place place) {
    places.add(place);
  }

  void removePlace(String placeId) {
    places.removeWhere((place) => place.id == placeId);
  }
}
