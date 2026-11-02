import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
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
}

String _poster(String seed) => 'https://picsum.photos/seed/$seed/400/600';

Movie _movie(String title, String year, String genre) => Movie(
      title: title,
      year: year,
      genre: genre,
      overview: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      poster: _poster(title.replaceAll(' ', '')),
    );

final List<Movie> nowPlaying = [
  _movie('Deadpool and Wolverine', '2024', 'Action'),
  _movie('Inside Out 2', '2024', 'Animation'),
  _movie('Twisters', '2024', 'Adventure'),
  _movie('Despicable Me 4', '2024', 'Comedy'),
  _movie('Alien Romulus', '2024', 'Horror'),
];

final List<Movie> trending = [
  _movie('Bad Boys Ride or Die', '2024', 'Action'),
  _movie('Kung Fu Panda 4', '2024', 'Animation'),
  _movie('A Quiet Place Day One', '2024', 'Horror'),
  _movie('Furiosa', '2024', 'Action'),
  _movie('Godzilla x Kong', '2024', 'Sci-Fi'),
  _movie('Dune Part Two', '2024', 'Sci-Fi'),
];

final List<Movie> popular = [
  _movie('The Brothers Sun', '2024', 'Drama'),
  _movie('Fallout', '2024', 'Sci-Fi'),
  _movie('Next Goal Wins', '2023', 'Comedy'),
  _movie('Oppenheimer', '2023', 'Drama'),
  _movie('Barbie', '2023', 'Comedy'),
  _movie('Civil War', '2024', 'Action'),
];

final List<Movie> topRated = [
  _movie('Mountain Sled', '2023', 'Drama'),
  _movie('Anatomy of a Fall', '2023', 'Drama'),
  _movie('Perfect Days', '2023', 'Drama'),
  _movie('The Godfather', '1972', 'Crime'),
  _movie('Parasite', '2019', 'Thriller'),
  _movie('Spirited Away', '2001', 'Animation'),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      builder: (context, child) => Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: child,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: SingleChildScrollView(
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
      ),
    );
  }
}

class PosterImage extends StatelessWidget {
  final String url;
  const PosterImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(color: Colors.grey[900]);
      },
      errorBuilder: (context, error, stack) => Container(
        color: Colors.grey[850],
        child: const Center(
          child: Icon(Icons.movie, color: Colors.white54),
        ),
      ),
    );
  }
}

class MovieSlide extends StatelessWidget {
  final Movie movie;
  const MovieSlide({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PosterImage(url: movie.poster),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${movie.year}   ${movie.genre}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.chevron_right, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  const MovieSection({super.key, required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'More',
                style: TextStyle(fontSize: 11, color: Colors.white54),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: PosterImage(url: movies[index].poster),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}