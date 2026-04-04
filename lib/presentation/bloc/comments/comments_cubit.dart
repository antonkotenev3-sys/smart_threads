import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/comment.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentRepository _repository;
  final String _postId;

  CommentsCubit(this._repository, this._postId) : super(const CommentsState());

  // 1) "load" — получаем данные из репозитория
  Future<void> load() async {
    emit(state.copyWith(status: CommentsStatus.loading));
    try {
      final comments = await _repository.getComments(_postId);
      emit(state.copyWith(status: CommentsStatus.success, comment: comments));
    } catch (e) {
      emit(state.copyWith(status: CommentsStatus.failure));
    }
  }

  // 2) "add_comment" — создаем комментария и обновление UI
  Future<void> addComment() async {
    if (!state.canSubmit) return;

    try {
      final commentToSave = Comment(
        id: DateTime.now().millisecondsSinceEpoch
            .toString(), // Временный ID для UI
        postId: _postId,
        content: state.inputText,
        createdAt: DateTime.now().toString(),
      );
      await _repository.addComment(commentToSave);

      final List<Comment> updatedList = List<Comment>.from(state.comment);
      updatedList.add(commentToSave);

      emit(state.copyWith(comment: updatedList, inputText: ''));
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // 3) "input_change" — сохраняем текст из TextFormField в стейт
  void inputChange(String text) {
    emit(state.copyWith(inputText: text));
  }
}
