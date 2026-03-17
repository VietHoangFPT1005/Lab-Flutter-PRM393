// Lab 8 – JSON Model Class
// Represents a post from https://jsonplaceholder.typicode.com/posts

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // Lab 8.2 – factory fromJson constructor
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  // Optional: toJson for POST requests
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'body': body,
      };
}
