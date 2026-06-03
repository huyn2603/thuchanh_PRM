import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final Movie movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorite = false;
  int _userRating = 0;

  Movie get movie => widget.movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            title: Text(movie.title),
            flexibleSpace: FlexibleSpaceBar(
              background: HeroBanner(movie: movie),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres
                        .map((genre) => Chip(label: Text(genre)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating.toStringAsFixed(1)} / 10',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(movie.overview),
                  const SizedBox(height: 18),
                  MovieActionBar(
                    isFavorite: _isFavorite,
                    userRating: _userRating,
                    onFavorite: _toggleFavorite,
                    onRate: _showRateDialog,
                    onShare: _shareMovie,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Trailers',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movie.trailers.length,
                    itemBuilder: (context, index) {
                      final trailer = movie.trailers[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          child: Icon(Icons.play_arrow),
                        ),
                        title: Text(trailer.title),
                        subtitle: Text(trailer.duration),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Playing ${trailer.title}')),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _showRateDialog() async {
    final selectedRating = await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Rate this movie'),
          children: List.generate(5, (index) {
            final rating = index + 1;
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, rating),
              child: Row(
                children: [
                  Text('$rating'),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.star,
                    color: rating <= _userRating ? Colors.amber : null,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );

    if (selectedRating != null) {
      setState(() {
        _userRating = selectedRating;
      });
    }
  }

  void _shareMovie() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Shared ${movie.title}')));
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'poster-${movie.id}',
          child: Image.network(
            movie.posterUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: const Icon(Icons.movie, size: 72),
              );
            },
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withAlpha(30), Colors.black.withAlpha(210)],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: Text(
            movie.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class MovieActionBar extends StatelessWidget {
  const MovieActionBar({
    super.key,
    required this.isFavorite,
    required this.userRating,
    required this.onFavorite,
    required this.onRate,
    required this.onShare,
  });

  final bool isFavorite;
  final int userRating;
  final VoidCallback onFavorite;
  final VoidCallback onRate;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          label: isFavorite ? 'Saved' : 'Favorite',
          onPressed: onFavorite,
        ),
        _ActionButton(
          icon: Icons.star_rate,
          label: userRating == 0 ? 'Rate' : '$userRating/5',
          onPressed: onRate,
        ),
        _ActionButton(icon: Icons.share, label: 'Share', onPressed: onShare),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon)),
        Text(label),
      ],
    );
  }
}
