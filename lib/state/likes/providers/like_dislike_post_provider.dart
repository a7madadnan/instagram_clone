import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/likes/models/like_dislike_request.dart';

import '../models/like.dart';

final likeDislikePostProvider = FutureProvider.family
    .autoDispose<bool, LikeDislikeRequest>(
        (ref, LikeDislikeRequest request) async {
  final query = FirebaseFirestore.instance
      .collection(FirebaseCollectiondName.likes)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .where(FirebaseFieldName.userId, isEqualTo: request.userId)
      .get();
  //see if the user has liked the post
  final hasLiked = await query.then(
    (snapshot) => snapshot.docs.isNotEmpty,
  );
  if (hasLiked) {
    try {
      await query.then((snapshot) async {
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      });
      return true;
    } catch (_) {
      return false;
    }
  } else {
    final like = Like(
        postId: request.postId, userId: request.userId, date: DateTime.now());
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectiondName.likes)
          .add(like);
      return true;
    } catch (_) {
      return false;
    }
  }
});
