import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/sample_data.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String _searchQuery = '';
  final Set<String> _selectedGenres = {};
  String _sortOption = 'A-Z';

  final List<String> _sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

  List<Movie> get _visibleMovies {
    // 1. Filter by search query
    List<Movie> filtered = allMovies.where((movie) {
      final matchesSearch =
          movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenres.isEmpty ||
          movie.genres.any((g) => _selectedGenres.contains(g));
      return matchesSearch && matchesGenre;
    }).toList();

    // 2. Sort
    switch (_sortOption) {
      case 'A-Z':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        filtered.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleMovies;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title (Lab 6.1) ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Find a Movie',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                if (_selectedGenres.isNotEmpty)
                  // Badge showing selected genre count (bonus)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_selectedGenres.length} genre${_selectedGenres.length > 1 ? 's' : ''}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Search Bar (Lab 6.2) ─────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search by title...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            const SizedBox(height: 12),

            // ── Genre Chips using Wrap (Lab 6.2) ────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: allGenres.map((genre) {
                final isSelected = _selectedGenres.contains(genre);
                return FilterChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (_) => _toggleGenre(genre),
                  selectedColor: Colors.deepPurple,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[300],
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.grey[800],
                );
              }).toList(),
            ),
            const SizedBox(height: 8),

            // ── Sort Bar (Lab 6.2) ───────────────────────────────────
            Row(
              children: [
                const Text('Sort by:',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _sortOption,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  underline: const SizedBox(),
                  items: _sortOptions
                      .map((opt) =>
                          DropdownMenuItem(value: opt, child: Text(opt)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _sortOption = val ?? 'A-Z'),
                ),
                const Spacer(),
                if (_selectedGenres.isNotEmpty)
                  TextButton(
                    onPressed: () =>
                        setState(() => _selectedGenres.clear()),
                    child: const Text('Clear filters',
                        style: TextStyle(color: Colors.deepPurpleAccent)),
                  ),
              ],
            ),
            const SizedBox(height: 4),

            // ── Responsive Movie List (Lab 6.3) ──────────────────────
            Expanded(
              child: visible.isEmpty
                  ? const Center(
                      child: Text('No movies found.',
                          style: TextStyle(color: Colors.grey)))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Breakpoint: >= 800px → 2 columns
                        if (constraints.maxWidth >= 800) {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: visible.length,
                            itemBuilder: (context, index) =>
                                _MovieCard(movie: visible[index]),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: visible.length,
                            itemBuilder: (context, index) =>
                                Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _MovieCard(movie: visible[index]),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Movie Card Widget ─────────────────────────────────────────────────────────
class _MovieCard extends StatelessWidget {
  final Movie movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Adjust poster height based on available width
      final posterHeight = constraints.maxWidth < 200 ? 120.0 : 180.0;

      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                movie.posterUrl,
                height: posterHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: posterHeight,
                  color: Colors.grey[700],
                  child: const Icon(Icons.movie,
                      color: Colors.white54, size: 40),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${movie.year}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: Colors.amber, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: movie.genres
                        .map((g) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(g,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 10)),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
