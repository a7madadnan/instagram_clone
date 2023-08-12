import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/comments/extentions/comment_sorting_by_request.dart';
import 'package:instant_gram/state/comments/models/comment.dart';
import 'package:instant_gram/state/comments/models/post_comments_request.dart';
import 'package:instant_gram/state/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';

final postCommentsProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>(
  (ref, RequestForPostAndComments request) {
    final controller = StreamController<Iterable<Comment>>();
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectiondName.comments)
        .where(FirebaseFieldName.postId, isEqualTo: request.postId)
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;
        final limitedDocument =
            request.limit != null ? documents.take(request.limit!) : documents;
        final comments = limitedDocument
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (document) => Comment(document.data(), id: document.id),
            );
        final result = comments.applySortingFrom(request);
        controller.sink.add(result);
      },
    );
    ref.onDispose(
      () {
        sub.cancel();
        controller.close();
      },
    );
    return controller.stream;
  },
);
