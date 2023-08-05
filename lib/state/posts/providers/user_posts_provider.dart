import 'dart:async';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/user_id_provider.dart';
import 'package:instant_gram/state/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/state/posts/models/post_key.dart';

final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    final userId = ref.watch(userIdProvider);
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
        .where(
          PostKey.userId,
          isEqualTo: userId,
        )
        .snapshots()
        .listen((snapShot) {
      final documents = snapShot.docs;
      final posts = documents
          .where(
            (doc) => !doc.metadata.hasPendingWrites,
          )
          .map(
            (doc) => Post(
              postId: doc.id,
              json: doc.data(),
            ),
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
