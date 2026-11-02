import 'package:flutter/material.dart';

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