import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/comments/extentions/comment_sorting_by_request.dart';
import 'package:instant_gram/state/comments/models/post_comments_request.dart';
import 'package:instant_gram/state/comments/models/post_with_comments.dart';
import 'package:instant_gram/state/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/posts/models/post.dart';

import '../../comments/models/comment.dart';

final specificPostWithCommentsProvider = StreamProvider.family
    .autoDispose<PostWithComments, RequestForPostAndComments>(
        (ref, RequestForPostAndComments request) {
  final controller = StreamController<PostWithComments>();
  Post? post;
  Iterable<Comment>? comments;

  void notify() {
    final localPost = post;
    if (localPost == null) {
      return;
    }
    final outputComments = (comments ?? []).applySortingFrom(
      request,
    );
    final result = PostWithComments(
      comments: outputComments,
      post: localPost,
    );
    controller.sink.add(result);
  }

  final postSub = FirebaseFirestore.instance
      .collection(
        FirebaseCollectiondName.posts,
      )
      .where(
        FieldPath.documentId,
        isEqualTo: request.postId,
      )
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isEmpty) {
      post = null;
      comments = null;
      notify();
      return;
    }
    final doc = snapshot.docs.first;
    if (doc.metadata.hasPendingWrites) {
      return;
    }
    post = Post(
      postId: doc.id,
      json: doc.data(),
    );
    notify();
  });
  final commentsQuery = FirebaseFirestore.instance
      .collection(
        FirebaseCollectiondName.comments,
      )
      .where(
        FirebaseFieldName.postId,
        isEqualTo: request.postId,
      )
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      );
  final limitedCommentsQuery = request.limit != null
      ? commentsQuery.limit(request.limit!)
      : commentsQuery;
  final commentsSub = limitedCommentsQuery.snapshots().listen((snapshot) {
    comments = snapshot.docs
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Comment(
            doc.data(),
            id: doc.id,
          ),
        )
        .toList();
    notify();
  });
  ref.onDispose(() {
    postSub.cancel();
    commentsSub.cancel();
    controller.close();
  });
  return controller.stream;
});
