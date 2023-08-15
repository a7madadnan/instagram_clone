import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../posts/models/post.dart';
import 'comment.dart';

@immutable
class PostWithComments {
  final Post post;
  final Iterable<Comment> comments;
  const PostWithComments({
    required this.comments,
    required this.post,
  });
  @override
  bool operator ==(covariant PostWithComments other) =>
      runtimeType == other.runtimeType &&
      post == other.post &&
      const IterableEquality().equals(comments, other.comments);

  @override
  int get hashCode => Object.hashAll(
        [
          post,
          comments,
        ],
      );
}
