import 'package:smart_threads/data/datasourses/local_comment_data_source.dart';
import 'package:smart_threads/data/models/comment_model.dart';
import 'package:smart_threads/domain/entities/comment.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final LocalCommentDataSource _local;

  CommentRepositoryImpl(this._local);

  @override
  Future<void> addComment(Comment comment) async {
    await _local.saveComment(CommentModel.fromEntity(comment));
  }

  @override
  Future<int> getCommentsCount(String postId) async {
    return await _local.getCountByPost(postId);
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    final models = await _local.getCommentsByPost(postId);
    return models.map((m) => m.toEntity()).toList();
  }
}
