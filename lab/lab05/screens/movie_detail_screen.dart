import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/action_button.dart';
import '../widgets/trailer_card.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late bool _isFavorite;
  bool _initialized = false;
  double _userRating = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Movie movie = args['movie'];

    if (!_initialized) {
      _isFavorite = args['isFavorite'] ?? false;
      _initialized = true;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'poster_${movie.id}',
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.movie, size: 100),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.8),
                          Colors.black,
                        ],
                        stops: const [0.0, 0.5, 0.8, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 22),
                            const SizedBox(width: 4),
                            Text('${movie.rating}/10',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            const Icon(Icons.access_time, size: 18),
                            const SizedBox(width: 4),
                            Text(movie.duration),
                            const SizedBox(width: 16),
                            const Icon(Icons.calendar_today, size: 18),
                            const SizedBox(width: 4),
                            Text(movie.releaseDate),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Genres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres.map((genre) => Chip(
                      label: Text(genre),
                      backgroundColor: Colors.deepPurple.shade700,
                      labelStyle: const TextStyle(color: Colors.white),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(movie.overview,
                      style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey.shade300)),
                  const SizedBox(height: 24),
                  const Text('Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                        icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                        label: _isFavorite ? 'Favorited' : 'Favorite',
                        color: _isFavorite ? Colors.red : Colors.white,
                        onPressed: () {
                          setState(() => _isFavorite = !_isFavorite);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_isFavorite ? 'Added to favorites!' : 'Removed from favorites'),
                                duration: const Duration(seconds: 1)),
                          );
                        },
                      ),
                      ActionButton(
                        icon: Icons.star_rate,
                        label: _userRating > 0 ? 'Rated ${_userRating.toInt()}' : 'Rate',
                        color: _userRating > 0 ? Colors.amber : Colors.white,
                        onPressed: () => _showRatingDialog(context),
                      ),
                      ActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        color: Colors.white,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sharing "${movie.title}"...'),
                                duration: const Duration(seconds: 1)),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Trailers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => TrailerCard(trailer: movie.trailers[index]),
              childCount: movie.trailers.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rate this movie'),
        content: StatefulBuilder(
          builder: (builderContext, setDialogState) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final rating = index + 1;
              return IconButton(
                onPressed: () {
                  setState(() => _userRating = rating.toDouble());
                  Navigator.pop(dialogContext);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('You rated this movie $rating stars!'),
                        duration: const Duration(seconds: 1)),
                  );
                },
                icon: Icon(Icons.star, size: 36,
                    color: index < _userRating ? Colors.amber : Colors.grey),
              );
            }),
          ),
        ),
      ),
    );
  }
}