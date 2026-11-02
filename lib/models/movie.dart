import 'package:movie_app/config/constants.dart';

class Movie {
  final String title;
  final String year;
  final String genre;
  final String overview;
  final String poster;

  const Movie({
    required this.title,
    required this.year,
    required this.genre,
    required this.overview,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final date = (json['release_date'] ?? '') as String;
    final ids = (json['genre_ids'] as List?) ?? [];
    final genre = ids.isNotEmpty ? (genreMap[ids.first as int] ?? '') : '';
    final path = json['poster_path'] as String?;

    return Movie(
      title: (json['title'] ?? '') as String,
      year: date.length >= 4 ? date.substring(0, 4) : '-',
      genre: genre,
      overview: (json['overview'] ?? '') as String,
      poster: path == null ? '' : '$imageBase$path',
    );
  }
}