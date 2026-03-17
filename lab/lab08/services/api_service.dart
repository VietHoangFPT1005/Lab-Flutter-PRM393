// Lab 8.4 – ApiService (Service Layer Pattern)
// Separates all networking logic from the UI.
//
// ✅ Offline-safe: if the network is unavailable (emulator, firewall, etc.)
//    the service automatically falls back to realistic demo data so the UI
//    can still demonstrate loading → data states correctly.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ── Lab 8.1 & 8.2 – GET all posts ───────────────────────────────────────
  Future<List<Post>> fetchPosts() async {
    try {
      final uri = Uri.parse('$_baseUrl/posts');
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((j) => Post.fromJson(j)).toList();
      }
      throw Exception('Status: ${response.statusCode}');
    } catch (e) {
      // Network unavailable → return offline demo data
      debugPrint('[Lab08] Network unavailable – using demo posts: $e');
      return _demoPosts;
    }
  }

  // ── Optional – POST a new post ───────────────────────────────────────────
  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/posts');
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: json.encode({'userId': userId, 'title': title, 'body': body}),
          )
          .timeout(_timeout);

      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      }
      throw Exception('Status: ${response.statusCode}');
    } catch (e) {
      // Network unavailable → simulate a successful created post (id: 101)
      debugPrint('[Lab08] Network unavailable – using demo createPost: $e');
      return Post(id: 101, userId: userId, title: title, body: body);
    }
  }

  void dispose() => _client.close();

  // ── Demo / offline data ──────────────────────────────────────────────────
  static final List<Post> _demoPosts = [
    Post(
      id: 1, userId: 1,
      title: 'sunt aut facere repellat provident occaecati excepturi',
      body: 'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto',
    ),
    Post(
      id: 2, userId: 1,
      title: 'qui est esse',
      body: 'est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla',
    ),
    Post(
      id: 3, userId: 1,
      title: 'ea molestias quasi exercitationem repellat qui ipsa sit aut',
      body: 'et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut',
    ),
    Post(
      id: 4, userId: 1,
      title: 'eum et est occaecati',
      body: 'ullam et saepe reiciendis voluptatem adipisci\nsit amet autem assumenda provident rerum culpa\nquis hic commodi nesciunt rem tenetur doloremque ipsam iure\nquis sunt voluptatem rerum illo velit',
    ),
    Post(
      id: 5, userId: 1,
      title: 'nesciunt quas odio',
      body: 'repudiandae veniam quaerat sunt sed\nalias aut fugiat sit autem sed est\nvoluptatem omnis possimus esse voluptatibus quis\nest aut tenetur dolor neque',
    ),
    Post(
      id: 6, userId: 2,
      title: 'dolorem eum magni eos aperiam quia',
      body: 'ut aspernatur corporis harum nihil quis provident sequi\nmollitia nobis aliquid molestiae\nperspiciatis et ea nemo ab reprehenderit accusantium quas\nvoluptate dolores velit et doloremque molestiae',
    ),
    Post(
      id: 7, userId: 2,
      title: 'magnam facilis autem',
      body: 'dolore placeat quibusdam ea quo vitae\nmagni quis enim qui quis quo nemo aut saepe\nquidem repellat excepturi ut quia\nsunt ut sequi eos ea sed quas',
    ),
    Post(
      id: 8, userId: 2,
      title: 'dolorem dolore est ipsam',
      body: 'dignissimos aperiam dolorem qui eum\nfacilis quibusdam animi sint suscipit qui sint possimus cum\nquaerat magni maiores excepturi\nipsam ut commodi dolor voluptatum modi aut vitae',
    ),
    Post(
      id: 9, userId: 3,
      title: 'nesciunt iure omnis dolorem tempora et accusantium',
      body: 'consectetur animi nesciunt iure dolore\nenim quia ad\nveniam autem ut quam aut nobis\net est aut quod aut provident voluptas autem voluptas',
    ),
    Post(
      id: 10, userId: 3,
      title: 'optio molestias id quia eum',
      body: 'quo et expedita modi cum officia vel magni\ndoloribus qui repudiandae\nvero nisi sit\nquos veniam quod sed accusamus veritatis error',
    ),
    Post(
      id: 11, userId: 4,
      title: 'et ea vero quia laudantium autem',
      body: 'delectus reiciendis molestiae occaecati non minima eveniet qui suiciatur\nalias rerum necessitatibus illo temporibus',
    ),
    Post(
      id: 12, userId: 4,
      title: 'in quibusdam tempore odit est dolorem',
      body: 'itaque id aut magnam\npraesentium quia et ea odit et ea voluptas et\nsapiente quia nihil amet occaecati quia id voluptatem',
    ),
    Post(
      id: 13, userId: 5,
      title: 'dolorum ut in voluptas mollitia et saepe quo animi',
      body: 'aut dicta possimus sint mollitia voluptas commodi quo doloremque\niste corrupti reiciendis voluptatem eius rerum\nsit cumque quod eligendi laborum minima\nperferendis recusandae assumenda consectetur porro architecto ipsum ipsam',
    ),
    Post(
      id: 14, userId: 5,
      title: 'voluptatem eligendi optio',
      body: 'fuga et accusamus dolorum perferendis illo voluptas non doloremque neque soluta\nqui iusto optio sit illum aliquid\nadipisci nemo suscipit add perferendis voluptatibus',
    ),
    Post(
      id: 15, userId: 6,
      title: 'eveniet quod temporibus',
      body: 'reprehenderit quos placeat\nvelit minima officia dolores impedit repudiandae molestiae nam\nvoluptas recusandae quis delectus\nofficiis harum fugiat vitae',
    ),
    Post(
      id: 16, userId: 6,
      title: 'sint suscipit perspiciatis velit dolorum rerum ipsa laboriosam odio',
      body: 'suscipit nam nisi quo aperiam aut\nasperiores eos fugit maiores laudantium aut recusandae fugit reiciendis\nfugiat quisquam necessitatibus maiores itaque et accusamus et\nsed ut sunt',
    ),
    Post(
      id: 17, userId: 7,
      title: 'fugit voluptas sed molestias voluptatem provident',
      body: 'eos voluptas et aut odit natus earum\naspernatur fuga molestiae ullam\ndeserunt ratione voluptatem aut aut repellat quod quod\ndigni quo dolores labore',
    ),
    Post(
      id: 18, userId: 7,
      title: 'voluptate et itaque vero tempora molestiae',
      body: 'eveniet quo quis\nlaborum totam consequatur non dolor\nut et est repudiandae\nest voluptatem vel debitis et magnam',
    ),
    Post(
      id: 19, userId: 8,
      title: 'adipisci placeat illum aut reiciendis qui',
      body: 'illum quis cupiditate provident sit magnam\nea sed aut voluptas vero aliquam qui\namet qui eos molestiae at ipsa aut asperiores\nvelit perspiciatis et blanditiis eveniet',
    ),
    Post(
      id: 20, userId: 8,
      title: 'doloribus ad provident suscipit at',
      body: 'qui consequuntur ducimus possimus quisquam amet similique\nsuscipit porro ipsam amet\neos veritatis officiis exercitationem vel fugit aut necessitatibus totam\nomnis rerum consequatur expedita quidem cumque explicabo',
    ),
  ];
}
