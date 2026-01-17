import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../models/place.dart';
import 'dart:convert';

class StorageService {
  static const String _citiesKey = 'cities_data';
  List<City> _cities = [];

  Future<void> init() async {
    await _loadCities();
  }

  Future<void> _loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final citiesJson = prefs.getString(_citiesKey);

    if (citiesJson != null) {
      final List<dynamic> citiesList = json.decode(citiesJson);
      _cities = citiesList.map((cityJson) => City.fromJson(cityJson)).toList();
    } else {
      _cities = [];
    }
  }

  Future<void> _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    final citiesJson = json.encode(
      _cities.map((city) => city.toJson()).toList(),
    );
    await prefs.setString(_citiesKey, citiesJson);
  }

  List<City> getCities() {
    return List.from(_cities);
  }

  Future<void> addCity(String name) async {
    _cities.add(
      City(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name),
    );
    await _saveCities();
  }

  Future<void> deleteCity(String cityId) async {
    _cities.removeWhere((city) => city.id == cityId);
    await _saveCities();
  }

  City? getCityById(String cityId) {
    try {
      return _cities.firstWhere((city) => city.id == cityId);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateCity(City updatedCity) async {
    final index = _cities.indexWhere((city) => city.id == updatedCity.id);
    if (index != -1) {
      _cities[index] = updatedCity;
      await _saveCities();
    }
  }

  Future<void> addPlaceToCity(String cityId, String placeName) async {
    final city = getCityById(cityId);
    if (city != null) {
      city.addPlace(
        Place(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: placeName,
        ),
      );
      await updateCity(city);
    }
  }

  Future<void> deletePlaceFromCity(String cityId, String placeId) async {
    final city = getCityById(cityId);
    if (city != null) {
      city.removePlace(placeId);
      await updateCity(city);
    }
  }
}
