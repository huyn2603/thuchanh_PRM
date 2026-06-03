import '../models/movie.dart';

const List<Movie> sampleMovies = [
  Movie(
    id: 'm001',
    title: 'Interstellar',
    posterUrl:
        'https://image.tmdb.org/t/p/w780/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
    rating: 8.7,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    overview:
        'A team of explorers travels through a wormhole in space to find a new '
        'home for humanity while a father fights to return to his children.',
    trailers: [
      Trailer(title: 'Official Trailer', duration: '2:19'),
      Trailer(title: 'Docking Scene Preview', duration: '1:34'),
      Trailer(title: 'Behind the Score', duration: '3:08'),
    ],
  ),
  Movie(
    id: 'm002',
    title: 'The Dark Knight',
    posterUrl:
        'https://image.tmdb.org/t/p/w780/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    rating: 9.0,
    genres: ['Action', 'Crime', 'Thriller'],
    overview:
        'Batman faces a criminal mastermind who pushes Gotham into chaos and '
        'forces its heroes to question how far they should go for justice.',
    trailers: [
      Trailer(title: 'Main Trailer', duration: '2:12'),
      Trailer(title: 'Joker Featurette', duration: '2:45'),
      Trailer(title: 'Gotham Chaos Teaser', duration: '1:10'),
    ],
  ),
  Movie(
    id: 'm003',
    title: 'Spirited Away',
    posterUrl:
        'https://image.tmdb.org/t/p/w780/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg',
    rating: 8.6,
    genres: ['Animation', 'Fantasy', 'Family'],
    overview:
        'A young girl enters a mysterious spirit world and must discover her '
        'courage to rescue her parents and find the way back home.',
    trailers: [
      Trailer(title: 'Classic Trailer', duration: '1:58'),
      Trailer(title: 'Bathhouse World', duration: '2:04'),
      Trailer(title: 'Studio Featurette', duration: '3:31'),
    ],
  ),
  Movie(
    id: 'm004',
    title: 'Dune: Part Two',
    posterUrl:
        'https://image.tmdb.org/t/p/w780/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg',
    rating: 8.5,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    overview:
        'Paul Atreides unites with Chani and the Fremen while seeking revenge '
        'against those who destroyed his family.',
    trailers: [
      Trailer(title: 'Official Trailer 1', duration: '2:24'),
      Trailer(title: 'Official Trailer 2', duration: '2:39'),
      Trailer(title: 'Sandworm Sequence', duration: '1:42'),
    ],
  ),
];
