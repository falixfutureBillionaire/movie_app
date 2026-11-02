import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/config/constants.dart';
import 'package:movie_app/models/movie.dart';

Future<List<Movie>> fetchMovies(String endpoint) async {
  final uri = Uri.https('api.themoviedb.org', '/3/$endpoint', {
    'api_key': tmdbApiKey,
    'language': 'en-US',
  });

  final res = await http.get(uri);
  if (res.statusCode != 200) {
    throw Exception('Gagal load $endpoint (kode ${res.statusCode})');
  }

  final data = jsonDecode(res.body) as Map<String, dynamic>;
  final results = data['results'] as List;

  return results
      .map((e) => Movie.fromJson(e as Map<String, dynamic>))
      .where((m) => m.poster.isNotEmpty)
      .toList();
}