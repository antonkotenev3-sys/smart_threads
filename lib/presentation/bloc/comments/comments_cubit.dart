import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/comment.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentRepository _repository;
  final String _postId;

  CommentsCubit(this._repository, this._postId) : super(const CommentsState());

  //load comments
  Future<void> loadComments() async {
    emit(state.copyWith(status: CommentsStatus.loading));

    try {
      final comments = await _repository.getComments(_postId);
      emit(state.copyWith(comment: comments, status: CommentsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentsStatus.failure,
          errorMessage: 'Не удалось загрузить коментарий',
        ),
      );
    }
  }

  //addComment
  Future<void> addComment() async {
    if (!state.canSubmit) return;

    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: _postId,
      authorId: 'me',
      content: state.inputText.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await _repository.addComment(comment);

      emit(
        state.copyWith(
          inputText: '',
          status: CommentsStatus.success,
          comment: [...state.comment, comment],
        ),
      );
    } catch (e) {
      await loadComments();
    }
  }

  void updateInputText(String text) {
    emit(state.copyWith(inputText: text));
  }
}
