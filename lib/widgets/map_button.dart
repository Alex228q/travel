import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapButton extends StatelessWidget {
  final String cityName;
  final String placeName;
  final double? latitude;
  final double? longitude;

  const MapButton({
    super.key,
    required this.cityName,
    required this.placeName,
    this.latitude,
    this.longitude,
  });

  Future<void> _openMap(BuildContext context) async {
    String query = '';

    if (latitude != null && longitude != null) {
      query = '$latitude,$longitude';
    } else {
      query = '$cityName $placeName';
    }

    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedQuery',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Не удалось открыть карты')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.map, color: Colors.blue),
      onPressed: () => _openMap(context),
      tooltip: 'Открыть в Google Maps',
    );
  }
}
