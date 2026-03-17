import '../models/movie.dart';

const String _placeholderBase = 'https://picsum.photos/seed';

const List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: '$_placeholderBase/inception/300/450',
    rating: 8.8,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama', 'Crime'],
    posterUrl: '$_placeholderBase/darkknight/300/450',
    rating: 9.0,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama', 'Adventure'],
    posterUrl: '$_placeholderBase/interstellar/300/450',
    rating: 8.6,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: '$_placeholderBase/hangover/300/450',
    rating: 7.7,
  ),
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    posterUrl: '$_placeholderBase/endgame/300/450',
    rating: 8.4,
  ),
  Movie(
    title: 'Joker',
    year: 2019,
    genres: ['Drama', 'Crime', 'Thriller'],
    posterUrl: '$_placeholderBase/joker/300/450',
    rating: 8.4,
  ),
  Movie(
    title: 'Superbad',
    year: 2007,
    genres: ['Comedy'],
    posterUrl: '$_placeholderBase/superbad/300/450',
    rating: 7.6,
  ),
  Movie(
    title: 'The Shawshank Redemption',
    year: 1994,
    genres: ['Drama'],
    posterUrl: '$_placeholderBase/shawshank/300/450',
    rating: 9.3,
  ),
  Movie(
    title: 'Mad Max: Fury Road',
    year: 2015,
    genres: ['Action', 'Adventure', 'Thriller'],
    posterUrl: '$_placeholderBase/madmax/300/450',
    rating: 8.1,
  ),
  Movie(
    title: 'The Grand Budapest Hotel',
    year: 2014,
    genres: ['Comedy', 'Drama'],
    posterUrl: '$_placeholderBase/budapest/300/450',
    rating: 8.1,
  ),
];

const List<String> allGenres = [
  'Action',
  'Adventure',
  'Comedy',
  'Crime',
  'Drama',
  'Sci-Fi',
  'Thriller',
];
