import '../models/city.dart';
import '../models/place.dart';

class DataService {
  // Правильная реализация Singleton
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Данные теперь сохраняются между переходами
  final List<City> _cities = [];

  List<City> get cities => List.from(_cities);

  void addCity(String name) {
    final city = City(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    _cities.add(city);
  }

  void deleteCity(String cityId) {
    _cities.removeWhere((city) => city.id == cityId);
  }

  void addPlaceToCity(String cityId, String placeName) {
    final city = _cities.firstWhere((city) => city.id == cityId);
    final place = Place(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: placeName,
    );
    city.addPlace(place);
  }

  void deletePlaceFromCity(String cityId, String placeId) {
    final city = _cities.firstWhere((city) => city.id == cityId);
    city.removePlace(placeId);
  }

  City? getCityById(String cityId) {
    try {
      return _cities.firstWhere((city) => city.id == cityId);
    } catch (e) {
      return null;
    }
  }
}
