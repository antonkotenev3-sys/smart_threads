import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_cubit.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_state.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 20, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.authorId,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(post.content, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Секция лайка
                    _buildLikeSection(context),

                    const SizedBox(width: 25),
                    const Icon(Icons.mode_comment_outlined, size: 20),
                    const SizedBox(width: 25),
                    const Icon(Icons.repeat, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeSection(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      buildWhen: (previous, current) {
        final prevPost = previous.posts.firstWhere(
          (p) => p.id == post.id,
          orElse: () => post,
        );
        final currPost = current.posts.firstWhere(
          (p) => p.id == post.id,
          orElse: () => post,
        );
        return prevPost.isLiked != currPost.isLiked ||
            prevPost.likes != currPost.likes;
      },
      builder: (context, state) {
        final currentPost = state.posts.firstWhere(
          (p) => p.id == post.id,
          orElse: () => post,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => context.read<FeedCubit>().likePost(currentPost.id),
              child: Icon(
                currentPost.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: currentPost.isLiked ? Colors.red : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${currentPost.likes}',
              style: TextStyle(
                fontSize: 12,
                color: currentPost.isLiked ? Colors.red : Colors.grey[700],
              ),
            ),
          ],
        );
      },
    );
  }
}
