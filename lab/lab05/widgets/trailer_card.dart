import 'package:flutter/material.dart';
import '../models/trailer.dart';

class TrailerCard extends StatelessWidget {
  final Trailer trailer;

  const TrailerCard({super.key, required this.trailer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Playing: ${trailer.title}')),
          );
        },
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 70,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.movie, color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trailer.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(trailer.duration, style: TextStyle(color: Colors.grey.shade400)),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}