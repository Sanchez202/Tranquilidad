import 'comment.dart';
class Post {
  String id;
  String content;
  int likes;
  List<Comment> comments;

  Post({
    required this.id,
    required this.content,
    this.likes = 0,
    List<Comment>? comments,
  }) : comments = comments ?? [];
}
