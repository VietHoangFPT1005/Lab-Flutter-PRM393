// Lab 8 – Main Screen: API-powered Post List
// Covers: FutureBuilder, loading state, error state, ListView.builder

import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'create_post_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late final ApiService _apiService;
  late Future<List<Post>> _postsFuture;
  bool _isDemo = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _isDemo = false;
      _postsFuture = _apiService.fetchPosts().then((posts) {
        // If post id <= 20 and count == 20 it's likely demo data
        final isDemo = posts.isNotEmpty && posts.length <= 20 &&
            posts.every((p) => p.id <= 20);
        if (mounted) setState(() => _isDemo = isDemo);
        return posts;
      });
    });
  }

  void _retry() => _loadPosts();

  Future<void> _openCreatePost() async {
    final created = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
          builder: (_) => CreatePostScreen(apiService: _apiService)),
    );
    if (created != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Post #${created.id} created: "${created.title}"')),
      );
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts – Lab 8'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Retry',
            onPressed: _retry,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreatePost,
        icon: const Icon(Icons.add),
        label: const Text('New Post'),
      ),
      body: Column(
        children: [
          // ── Demo data banner ──────────────────────────────────────────
          if (_isDemo)
            Container(
              width: double.infinity,
              color: Colors.orange[100],
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.wifi_off,
                      size: 16, color: Colors.orange[800]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo data – no internet connection',
                      style: TextStyle(
                          fontSize: 12, color: Colors.orange[800]),
                    ),
                  ),
                ],
              ),
            ),

          // ── FutureBuilder ─────────────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                // ── Lab 8.3 – Loading State ────────────────────────────
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading posts...'),
                      ],
                    ),
                  );
                }

                // ── Lab 8.3 – Error State ──────────────────────────────
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.redAccent, size: 60),
                          const SizedBox(height: 16),
                          const Text(
                            'Something went wrong!',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _retry,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // ── Lab 8.2 – Data State ───────────────────────────────
                final posts = snapshot.data ?? [];
                if (posts.isEmpty) {
                  return const Center(
                      child: Text('No posts available.'));
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: Text(
                            '${post.id}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          post.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Chip(
                          label: Text('User ${post.userId}',
                              style:
                                  const TextStyle(fontSize: 10)),
                          padding: EdgeInsets.zero,
                        ),
                        onTap: () => _showPostDetail(context, post),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPostDetail(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Post #${post.id}',
                style:
                    const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 6),
            Text(post.title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(post.body,
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
