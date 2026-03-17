import 'trailer.dart';

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;
  final String releaseDate;
  final String duration;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    required this.releaseDate,
    required this.duration,
  });
}