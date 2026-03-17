
import 'package:flutter/material.dart';

class Exercise03 extends StatelessWidget {
  const Exercise03({super.key});

  // Danh sách phim mẫu
  final List<Map<String, dynamic>> movies = const [
    {'title': 'Avengers: Endgame', 'year': 2019, 'rating': 8.4, 'genre': 'Action'},
    {'title': 'The Dark Knight', 'year': 2008, 'rating': 9.0, 'genre': 'Action'},
    {'title': 'Inception', 'year': 2010, 'rating': 8.8, 'genre': 'Sci-Fi'},
    {'title': 'Interstellar', 'year': 2014, 'rating': 8.6, 'genre': 'Sci-Fi'},
    {'title': 'Parasite', 'year': 2019, 'rating': 8.5, 'genre': 'Thriller'},
    {'title': 'The Godfather', 'year': 1972, 'rating': 9.2, 'genre': 'Crime'},
    {'title': 'Pulp Fiction', 'year': 1994, 'rating': 8.9, 'genre': 'Crime'},
    {'title': 'Forrest Gump', 'year': 1994, 'rating': 8.8, 'genre': 'Drama'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3: Layout Basics'),
        backgroundColor: Colors.orange.shade100,
      ),
      // COLUMN: Sắp xếp các widget theo chiều dọc
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Header với PADDING
          Padding(
            padding: const EdgeInsets.all(16), // Padding đều 16px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ROW: Sắp xếp các widget theo chiều ngang
                Row(
                  children: [
                    // Icon phim
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.movie, size: 32, color: Colors.orange),
                    ),
                    const SizedBox(width: 16), // Spacing giữa các widget
                    // Tiêu đề
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Movie Collection',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Top rated movies of all time',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Section 2: Statistics Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16), // Padding trái phải
            child: Row(
              children: [
                // Sử dụng Expanded để chia đều không gian
                Expanded(child: _buildStatCard('Total', '${movies.length}', Icons.list, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Action', '2', Icons.sports_mma, Colors.red)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Sci-Fi', '2', Icons.rocket, Colors.purple)),
              ],
            ),
          ),

          const SizedBox(height: 16), // Spacing

          // Section 3: Category chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryChip('All', true),
                const SizedBox(width: 8),
                _buildCategoryChip('Action', false),
                const SizedBox(width: 8),
                _buildCategoryChip('Sci-Fi', false),
                const SizedBox(width: 8),
                _buildCategoryChip('Drama', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Movies List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          // Section 4: LISTVIEW với Expanded
          // QUAN TRỌNG: Phải dùng Expanded khi ListView nằm trong Column
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return _buildMovieCard(movie);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget thống kê
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  // Widget category chip
  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Widget movie card
  Widget _buildMovieCard(Map<String, dynamic> movie) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12), // Margin dưới mỗi card
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Poster placeholder
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.movie, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            // Movie info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${movie['year']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          movie['genre'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Rating
            Column(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(
                  '${movie['rating']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}