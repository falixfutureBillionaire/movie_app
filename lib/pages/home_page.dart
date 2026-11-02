import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/tmdb_service.dart';
import 'package:movie_app/widgets/movie_section.dart';
import 'package:movie_app/widgets/movie_slide.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<List<Movie>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<List<Movie>>> _load() {
    return Future.wait<List<Movie>>([
      fetchMovies('movie/now_playing'),
      fetchMovies('trending/movie/day'),
      fetchMovies('movie/popular'),
      fetchMovies('movie/top_rated'),
    ]);
  }

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Now Playing',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: FutureBuilder<List<List<Movie>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal load data.\nCek internet dan API key.\n\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final nowPlaying = snapshot.data![0].take(6).toList();
          final trending = snapshot.data![1];
          final popular = snapshot.data![2];
          final topRated = snapshot.data![3];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 360,
                    viewportFraction: 0.85,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                  ),
                  items: nowPlaying
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: MovieSlide(movie: m),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                MovieSection(title: 'Trending', movies: trending),
                MovieSection(title: 'Popular', movies: popular),
                MovieSection(title: 'Top Rated', movies: topRated),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}