import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:smart_threads/data/datasourses/local_post_datasource.dart';
import 'package:smart_threads/data/models/post_model.dart';
import 'package:smart_threads/data/respositories/post_repository_impl.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_cubit.dart';
import 'package:smart_threads/presentation/screens/feed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(PostModelAdapter());

  await _seedIfEmpty();

  runApp(const MyApp());
}

Future<void> _seedIfEmpty() async {
  final box = await Hive.openBox<PostModel>('posts');
  print('object');
  // if (box.isNotEmpty) return;
  print('object1');

  final posts = [
    Post(
      id: '1',
      content: 'Coffee was great!',
      authorId: 'alex',
      createdAt: '',
      likes: 5,
    ),
    Post(
      id: '2',
      content: 'Had a great day!',
      authorId: 'aigerim',
      createdAt: '',
      likes: 5,
    ),
    Post(
      id: '3',
      content: 'Developing Flutter app',
      authorId: 'marat',
      createdAt: '',
      likes: 5,
    ),
  ];

  await box.put(posts[0].id, PostModel.fromEntity(posts[0]));
  await box.put(posts[1].id, PostModel.fromEntity(posts[1]));
  await box.put(posts[2].id, PostModel.fromEntity(posts[2]));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final local = LocalPostDatasource();
    final repository = PostRepositoryImpl(local);

    return BlocProvider(
      create: (context) => FeedCubit(repository)..loadFeed(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const FeedScreen(),
      ),
    );
  }
}
