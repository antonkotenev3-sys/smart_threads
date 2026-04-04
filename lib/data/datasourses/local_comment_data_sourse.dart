import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:smart_threads/data/models/comment_model.dart';

class LocalCommentDataSource {
  static const _boxName = 'comments';

  Future<Box<CommentModel>> get _box async =>
      Hive.openBox<CommentModel>(_boxName);

  Future<List<CommentModel>> getCommentsByPost(String postId) async {
    final box = await _box;

    final comments = box.values.where((c) => c.postId == postId).toList();

    comments.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    return comments;
  }

  Future<void> saveComment(CommentModel comment) async {
    final box = await _box;
    await box.put(comment.id, comment);
  }

  Future<int> getCountByPost(String postId) async {
    final box = await _box;
    return box.values.where((c) => c.postId == postId).length;
  }
}
