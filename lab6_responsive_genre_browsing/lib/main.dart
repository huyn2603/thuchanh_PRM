import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 6 Responsive Movies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

class Movie {
  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });

  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;
}

const List<String> allGenres = [
  'Action',
  'Drama',
  'Comedy',
  'Sci-Fi',
  'Animation',
  'Adventure',
  'Thriller',
];

const List<Movie> allMovies = [
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/interstellar/360/520',
    rating: 8.7,
  ),
  Movie(
    title: 'The Grand Budapest Hotel',
    year: 2014,
    genres: ['Comedy', 'Drama', 'Adventure'],
    posterUrl: 'https://picsum.photos/seed/budapest/360/520',
    rating: 8.1,
  ),
  Movie(
    title: 'Spirited Away',
    year: 2001,
    genres: ['Animation', 'Adventure', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/spirited/360/520',
    rating: 8.6,
  ),
  Movie(
    title: 'Mad Max: Fury Road',
    year: 2015,
    genres: ['Action', 'Adventure', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/madmax/360/520',
    rating: 8.1,
  ),
  Movie(
    title: 'Arrival',
    year: 2016,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/arrival/360/520',
    rating: 7.9,
  ),
  Movie(
    title: 'Paddington 2',
    year: 2017,
    genres: ['Comedy', 'Animation', 'Adventure'],
    posterUrl: 'https://picsum.photos/seed/paddington/360/520',
    rating: 7.8,
  ),
];

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  String selectedSort = 'A-Z';
  final Set<String> selectedGenres = <String>{};

  List<Movie> get visibleMovies {
    final query = searchQuery.trim().toLowerCase();
    final movies = allMovies.where((movie) {
      final matchesSearch =
          query.isEmpty || movie.title.toLowerCase().contains(query);
      final matchesGenre =
          selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));
      return matchesSearch && matchesGenre;
    }).toList();

    // Sorting happens after filtering so the visible result stays predictable.
    switch (selectedSort) {
      case 'Z-A':
        movies.sort((a, b) => b.title.compareTo(a.title));
      case 'Year':
        movies.sort((a, b) => b.year.compareTo(a.year));
      case 'Rating':
        movies.sort((a, b) => b.rating.compareTo(a.rating));
      default:
        movies.sort((a, b) => a.title.compareTo(b.title));
    }

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWideScreen = width >= 800;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isWideScreen ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroHeading(isWideScreen: isWideScreen),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search by movie title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        isSelected
                            ? selectedGenres.remove(genre)
                            : selectedGenres.add(genre);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Badge(
                    label: Text('${selectedGenres.length}'),
                    isLabelVisible: selectedGenres.isNotEmpty,
                    child: const Icon(Icons.local_offer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text('${visibleMovies.length} movies found')),
                  TextButton(
                    onPressed: selectedGenres.isEmpty && searchQuery.isEmpty
                        ? null
                        : () {
                            setState(() {
                              selectedGenres.clear();
                              searchQuery = '';
                            });
                          },
                    child: const Text('Clear filters'),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(value: 'A-Z', child: Text('A-Z')),
                      DropdownMenuItem(value: 'Z-A', child: Text('Z-A')),
                      DropdownMenuItem(value: 'Year', child: Text('Year')),
                      DropdownMenuItem(value: 'Rating', child: Text('Rating')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (visibleMovies.isEmpty) {
                      return const Center(
                        child: Text('No movies match your filters.'),
                      );
                    }

                    if (constraints.maxWidth >= 800) {
                      return GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.7,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        children: visibleMovies
                            .map((m) => MovieCard(movie: m))
                            .toList(),
                      );
                    }

                    return ListView.builder(
                      itemCount: visibleMovies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MovieCard(movie: visibleMovies[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroHeading extends StatelessWidget {
  const _HeroHeading({required this.isWideScreen});

  final bool isWideScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWideScreen ? 28 : 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find a Movie',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search, filter by genre, and watch the layout adapt from phones to tablets.',
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final posterWidth = constraints.maxWidth >= 420 ? 118.0 : 94.0;
        final posterHeight = constraints.maxWidth >= 420 ? 160.0 : 142.0;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Image.network(
                movie.posterUrl,
                width: posterWidth,
                height: posterHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: posterWidth,
                    height: 142,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    child: const Icon(Icons.movie),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text('${movie.year}'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(movie.rating.toStringAsFixed(1)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
