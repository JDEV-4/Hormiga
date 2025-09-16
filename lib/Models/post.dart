class Post {
  final String author;
  final String time;
  final String text;
  final String image;
  final int likes;
  final int comments;
  final String type; // "official", "municipality", "citizen"
  final String avatarUrl; // 🔹 agregar

  Post({
    required this.author,
    required this.time,
    required this.text,
    required this.image,
    required this.likes,
    required this.comments,
    required this.type,
    required this.avatarUrl, // 🔹 obligatorio
  });
}
