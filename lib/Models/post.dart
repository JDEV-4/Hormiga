class Post {
  final String author;
  final String time;
  final String text;
  final String image;
  final int likes;
  final int comments;

  Post({
    required this.author,
    required this.time,
    required this.text,
    required this.image,
    this.likes = 0,
    this.comments = 0,
  });
}
