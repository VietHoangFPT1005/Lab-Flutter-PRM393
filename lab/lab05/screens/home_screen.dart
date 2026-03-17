import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  final Set<int> _favoriteIds = {};

  List<Movie> get _filteredMovies {
    if (_searchQuery.isEmpty) return sampleMovies;
    return sampleMovies.where((movie) =>
    movie.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        movie.genres.any((g) => g.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                '🎬 Movies Viet Hoang',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.shade900,
                      Colors.deepPurple.shade600,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search movies or genres...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final movie = _filteredMovies[index];
                  return MovieCard(
                    movie: movie,
                    isFavorite: _favoriteIds.contains(movie.id),
                    onFavoriteToggle: () {
                      setState(() {
                        if (_favoriteIds.contains(movie.id)) {
                          _favoriteIds.remove(movie.id);
                        } else {
                          _favoriteIds.add(movie.id);
                        }
                      });
                    },
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: {
                          'movie': movie,
                          'isFavorite': _favoriteIds.contains(movie.id),
                        },
                      );
                    },
                  );
                },
                childCount: _filteredMovies.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}