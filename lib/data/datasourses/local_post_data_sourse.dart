import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:smart_threads/data/models/post_model.dart';

class LocalPostDataSourse {
  static const _boxName = 'posts';

  Future<Box<PostModel>> get _box async => Hive.openBox<PostModel>(_boxName);

  Future<List<PostModel>> getPosts() async {
    final box = await _box;
    final posts = box.values.toList();
    return posts;
  }

  Future<void> savePost(PostModel post) async {
    final box = await _box;
    await box.put(post.id, post);
  }

  Future<void> updatePost(PostModel post) async {
    final box = await _box;
    await box.put(post.id, post);
  }

  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
