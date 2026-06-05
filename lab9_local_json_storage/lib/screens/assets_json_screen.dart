import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetsJsonScreen extends StatefulWidget {
  const AssetsJsonScreen({super.key});

  @override
  State<AssetsJsonScreen> createState() => _AssetsJsonScreenState();
}

class _AssetsJsonScreenState extends State<AssetsJsonScreen> {
  late Future<List<Map<String, dynamic>>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _loadAssetMovies();
  }

  Future<List<Map<String, dynamic>>> _loadAssetMovies() async {
    final rawJson = await rootBundle.loadString('assets/data/movies.json');
    final decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final movies = snapshot.data ?? const <Map<String, dynamic>>[];
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${movie['id']}')),
                title: Text(movie['title'] as String),
                subtitle: Text('${movie['genre']} - ${movie['year']}'),
              ),
            );
          },
        );
      },
    );
  }
}
