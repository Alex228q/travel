import 'package:flutter/material.dart';
import '../models/city.dart';
import '../services/storage_service.dart';
import '../widgets/map_button.dart';

class PlacesScreen extends StatefulWidget {
  final City city;
  final StorageService storageService;

  const PlacesScreen({
    super.key,
    required this.city,
    required this.storageService,
  });

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final TextEditingController _placeController = TextEditingController();
  late City _currentCity;

  @override
  void initState() {
    super.initState();
    _currentCity = widget.city;
  }

  void _showAddPlaceBottomSheet() {
    _placeController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Добавить место',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CloseButton(),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _placeController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Название места',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.place),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_placeController.text.trim().isNotEmpty) {
                        await _addPlace(_placeController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Добавить место',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addPlace(String placeName) async {
    // Делаем первую букву заглавной
    final formattedPlaceName = placeName.trim().isNotEmpty
        ? placeName.trim()[0].toUpperCase() +
              (placeName.trim().length > 1 ? placeName.trim().substring(1) : '')
        : '';

    if (formattedPlaceName.isNotEmpty) {
      await widget.storageService.addPlaceToCity(
        _currentCity.id,
        formattedPlaceName,
      );

      final updatedCity = widget.storageService.getCityById(_currentCity.id);
      if (updatedCity != null) {
        setState(() {
          _currentCity = City(
            id: updatedCity.id,
            name: updatedCity.name,
            places: List.from(updatedCity.places),
          );
        });
      }
      _placeController.clear();
    }
  }

  Future<void> _deletePlace(String placeId, String placeName) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить место?'),
        content: Text('Вы уверены, что хотите удалить "$placeName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.storageService.deletePlaceFromCity(_currentCity.id, placeId);

      final updatedCity = widget.storageService.getCityById(_currentCity.id);
      if (updatedCity != null) {
        setState(() {
          _currentCity = City(
            id: updatedCity.id,
            name: updatedCity.name,
            places: List.from(updatedCity.places),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Места в ${_currentCity.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_currentCity.places.length} ${_getPlacesText(_currentCity.places.length)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 2,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: _currentCity.places.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.explore, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 20),
                    const Text(
                      'Нет добавленных мест',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Нажмите на кнопку ниже, чтобы добавить первое место',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _currentCity.places.length,
                itemBuilder: (context, index) {
                  final place = _currentCity.places[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.place,
                                  color: Colors.blue.shade700,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (place.latitude != null &&
                                        place.longitude != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Координаты сохранены',
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MapButton(
                                    cityName: _currentCity.name,
                                    placeName: place.name,
                                    latitude: place.latitude,
                                    longitude: place.longitude,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade700,
                                      size: 22,
                                    ),
                                    onPressed: () =>
                                        _deletePlace(place.id, place.name),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlaceBottomSheet,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_location_alt, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _getPlacesText(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'место';
    if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 10 || count % 100 >= 20)) {
      return 'места';
    }
    return 'мест';
  }

  @override
  void dispose() {
    _placeController.dispose();
    super.dispose();
  }
}
