class PostEntity {
  final String title;
  final String author;
  final String date;
  final String content;
  final String avatarUrl;
  final String imageUrl;
  final String location; // obligatorio
  final int likes;
  final int comments;

  PostEntity({
    required this.title,
    required this.author,
    required this.date,
    required this.content,
    required this.avatarUrl,
    required this.imageUrl,
    required this.location,
    this.likes = 0,
    this.comments = 0,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      date: json['date'] ?? '',
      content: json['content'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'date': date,
      'content': content,
      'avatarUrl': avatarUrl,
      'imageUrl': imageUrl,
      'location': location,
      'likes': likes,
      'comments': comments,
    };
  }
}
