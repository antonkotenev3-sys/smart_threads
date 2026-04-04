import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/data/datasourses/local_post_data_sourse.dart';
import 'package:smart_threads/data/repositories/post_repository_impl.dart';
import 'package:smart_threads/presentation/bloc/create_post/create_post_cubit.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_cubit.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_state.dart';
import 'package:smart_threads/presentation/screens/create_post_screen.dart';
import 'package:smart_threads/presentation/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Threads',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) {
                      final local = LocalPostDataSourse();
                      final repository = PostRepositoryImpl(local);
                      return CreatePostCubit(repository);
                    },
                    child: const CreatePostScreen(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: BlocConsumer<FeedCubit, FeedState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == FeedStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.posts.isEmpty) {
            return Text('Список пуст');
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return PostCard(post: post);
            },
            separatorBuilder: (_, _) => Divider(height: 1),
            itemCount: state.posts.length,
          );
        },
      ),
    );
  }
}
