import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_threads/domain/entities/comment.dart';

part 'comment_model.g.dart';
part 'comment_model.freezed.dart';

@freezed
@HiveType(typeId: 1)
abstract class CommentModel with _$CommentModel {
  const CommentModel._();

  const factory CommentModel({
    @HiveField(0) String? id,
    @HiveField(1) String? postId,
    @HiveField(2) String? authorId,
    @HiveField(3) String? content,
    @HiveField(4) String? createdAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Comment toEntity() {
    return Comment(
      id: id,
      postId: postId,
      authorId: authorId,
      content: content,
      createdAt: createdAt,
    );
  }

  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      id: comment.id,
      postId: comment.postId,
      authorId: comment.authorId,
      content: comment.content,
      createdAt: comment.createdAt,
    );
  }
}
