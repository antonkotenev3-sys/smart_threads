import 'package:smart_threads/domain/entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getFeed();
  Future<void> createPost(Post post);
  Future<void> likePost(String postId);
}
