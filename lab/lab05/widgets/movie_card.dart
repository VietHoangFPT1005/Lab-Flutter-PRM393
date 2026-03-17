import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Hero(
              tag: 'poster_${movie.id}',
              child: Image.network(
                movie.posterUrl,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.movie, size: 40),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(movie.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(movie.duration, style: TextStyle(color: Colors.grey.shade400)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: movie.genres.take(2).map((g) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(g, style: const TextStyle(fontSize: 11)),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onFavoriteToggle,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}