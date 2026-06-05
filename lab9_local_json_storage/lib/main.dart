import 'package:flutter/material.dart';

import 'screens/assets_json_screen.dart';
import 'screens/local_crud_screen.dart';
import 'services/json_storage_service.dart';

void main() {
  runApp(JsonStorageApp(storageService: JsonStorageService()));
}

class JsonStorageApp extends StatelessWidget {
  const JsonStorageApp({super.key, required this.storageService});

  final JsonStorageService storageService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 9 JSON Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: JsonStorageHome(storageService: storageService),
    );
  }
}

class JsonStorageHome extends StatelessWidget {
  const JsonStorageHome({super.key, required this.storageService});

  final JsonStorageService storageService;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Local JSON Storage'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.inventory), text: 'Assets'),
              Tab(icon: Icon(Icons.storage), text: 'CRUD'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const AssetsJsonScreen(),
            LocalCrudScreen(storageService: storageService),
          ],
        ),
      ),
    );
  }
}
