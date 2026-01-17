import 'package:flutter/material.dart';
import '../models/city.dart';
import '../models/place.dart';

class CityProvider extends ChangeNotifier {
  final List<City> _cities = [];

  List<City> get cities => List.from(_cities);

  void addCity(String name) {
    _cities.add(
      City(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name),
    );
    notifyListeners();
  }

  void deleteCity(String cityId) {
    _cities.removeWhere((city) => city.id == cityId);
    notifyListeners();
  }

  void addPlaceToCity(String cityId, String placeName) {
    final city = _cities.firstWhere((city) => city.id == cityId);
    city.addPlace(
      Place(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: placeName,
      ),
    );
    notifyListeners();
  }

  void deletePlaceFromCity(String cityId, String placeId) {
    final city = _cities.firstWhere((city) => city.id == cityId);
    city.removePlace(placeId);
    notifyListeners();
  }

  City? getCityById(String cityId) {
    try {
      return _cities.firstWhere((city) => city.id == cityId);
    } catch (e) {
      return null;
    }
  }

  void updatePlaceCoordinates(
    String cityId,
    String placeId,
    double lat,
    double lng,
  ) {
    final city = getCityById(cityId);
    if (city != null) {
      final place = city.places.firstWhere((p) => p.id == placeId);
      place.latitude = lat;
      place.longitude = lng;
      notifyListeners();
    }
  }
}
