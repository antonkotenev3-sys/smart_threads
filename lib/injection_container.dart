import 'package:get_it/get_it.dart';
import 'package:smart_threads/data/datasourses/local_post_data_sourse.dart';
import 'package:smart_threads/data/repositories/post_repository_impl.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_cubit.dart';
import 'package:smart_threads/presentation/bloc/create_post/create_post_cubit.dart';

final sl = GetIt.instance; // sl — сокращение от Service Locator

Future<void> init() async {
  // 1. Data Sources (Источники данных)
  sl.registerLazySingleton(() => LocalPostDataSourse());

  // 2. Repositories (Репозитории)
  // Регистрируем реализацию для интерфейса PostRepository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      sl(),
    ), // sl() автоматически найдет LocalPostDataSourse
  );

  // 3. Blocs / Cubits
  // Используем registerFactory, чтобы каждый раз создавался новый экземпляр (для чистого состояния)
  sl.registerFactory(() => FeedCubit(sl()));
  sl.registerFactory(() => CreatePostCubit(sl()));
}
