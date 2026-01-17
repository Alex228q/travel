import 'package:flutter/material.dart';
import 'screens/cities_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мои города и места',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: CitiesScreen(storageService: storageService),
      debugShowCheckedModeBanner: false,
    );
  }
}
