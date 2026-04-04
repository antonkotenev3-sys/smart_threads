import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_state.freezed.dart';

enum CreatePostStatus { initial, loading, success, error }

@freezed
abstract class CreatePostState with _$CreatePostState {
  const factory CreatePostState({
    @Default(CreatePostStatus.initial) CreatePostStatus status,
    @Default('') String content,
    String? imagePath,
    String? errorMessage,
  }) = _CreatePostState;

  const CreatePostState._();

  bool get canSubmit =>
      content.trim().isNotEmpty && status != CreatePostStatus.loading;
}
