import 'package:smart_threads/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<void> addComment(Comment comment);
  Future<int> getCommentsCount(String postId);
}
