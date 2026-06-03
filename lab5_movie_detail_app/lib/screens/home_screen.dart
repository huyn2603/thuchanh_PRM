import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredMovies = sampleMovies.where((movie) {
      final keyword = _searchText.toLowerCase();
      return movie.title.toLowerCase().contains(keyword) ||
          movie.genres.any((genre) => genre.toLowerCase().contains(keyword));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Explorer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search movies',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Search is optional in the lab, implemented with simple state.
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                return MovieCard(
                  movie: filteredMovies[index],
                  onTap: () => _openDetails(context, filteredMovies[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        // The selected Movie object is passed directly to the detail screen.
        builder: (_) => MovieDetailScreen(movie: movie),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Hero(
              tag: 'poster-${movie.id}',
              child: Image.network(
                movie.posterUrl,
                width: 96,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 96,
                    height: 140,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: const Icon(Icons.movie),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(movie.rating.toStringAsFixed(1)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.genres.join(' / '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
