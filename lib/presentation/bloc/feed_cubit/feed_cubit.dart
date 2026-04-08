import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final PostRepository repository;

  FeedCubit(this.repository) : super(const FeedState());

  Future<void> loadFeed() async {
    emit(state.copyWith(status: FeedStatus.loading, errorMessage: null));

    try {
      final posts = await repository.getFeed();
      emit(state.copyWith(status: FeedStatus.success, posts: posts));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка', status: FeedStatus.failure));
    }
  }

  Future<void> addPost(String content) async {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      authorId: 'me',
      createdAt: DateTime.now().toIso8601String(),
      likes: 0,
    );

    await repository.createPost(newPost);

    await loadFeed();
  }

  Future<void> likePost(String postId) async {
    final List<Post> updatedPosts = state.posts.map((post) {
      if (post.id != postId) return post;

      return post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
    }).toList();

    try {
      await repository.likePost(postId);
      emit(state.copyWith(posts: updatedPosts));
    } catch (e) {
      await loadFeed();
    }
  }
}