import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/domain/repositories/post_repository.dart';
import 'package:smart_threads/presentation/bloc/create_post/create_post_state.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _repository;
  final _picker = ImagePicker();

  CreatePostCubit(this._repository) : super(const CreatePostState());

  void contentChanged(String value) {
    emit(state.copyWith(content: value));
  }

  Future<void> pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return;

    emit(state.copyWith(imagePath: file.path));
  }

  void removeImage() => emit(state.copyWith(imagePath: null));

  Future<void> submit() async {
    if (!state.canSubmit) return;

    try {
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: state.content.trim(),
        authorId: 'me',
        createdAt: DateTime.now().toIso8601String(),
        likes: 0,
      );

      await _repository.createPost(newPost);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: CreatePostStatus.error, errorMessage: 'Ошибка'),
      );
    }
  }
}
