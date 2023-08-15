import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import '../../constants/firebase_collection_name.dart';
import '../../constants/firebase_field_name.dart';

final allPostsProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    final controller = StreamController<Iterable<Post>>();
    controller.onListen = () {
      controller.sink.add([]);
    };
    final sub = FirebaseFirestore.instance
        .collection(
          FirebaseCollectiondName.posts,
        )
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true,
        )
        .snapshots()
        .listen((snapShot) {
      final documents = snapShot.docs;
      final posts = documents
          .where(
        (doc) => !doc.metadata.hasPendingWrites,
      )
          .map(
        (doc) {
          return Post(
            postId: doc.id,
            json: doc.data(),
          );
        },
      );
      controller.sink.add(posts);
    });
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);
