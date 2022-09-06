class ArticlePost {
  final int id;
  final int userId;
  final String title;
  final String body;

  ArticlePost({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory ArticlePost.fromJson(Map<String, dynamic> json) {
    return ArticlePost(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}
