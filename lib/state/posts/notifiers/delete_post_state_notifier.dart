import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/image_upload/extentions/get_collection_name_from_file_type.dart';
import 'package:instant_gram/state/image_upload/typedefs/is_loading.dart';
import 'package:instant_gram/state/posts/models/post.dart';

import '../typedefs/post_id.dart';

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);
  set isLoading(bool value) => state = value;
  Future<bool> deletePost({required Post post}) async {
//delete post thumbnail
    try {
      isLoading = true;
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectiondName.thumbnails)
          .child(post.thumbnailStorageId)
          .delete();
      //delete post origional video or image
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.collectionName)
          .child(post.origionalFileStorageId)
          .delete();
      //delete comments
      await _deleteAllDocuments(
        postId: post.postId,
        inCollection: FirebaseCollectiondName.comments,
      );
      //delete likes
      await _deleteAllDocuments(
        postId: post.postId,
        inCollection: FirebaseCollectiondName.likes,
      );
      //delete the post
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectiondName.posts)
          .where(FieldPath.documentId, isEqualTo: post.postId)
          .limit(1)
          .get();
      for (final post in postInCollection.docs) {
        await post.reference.delete();
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocuments(
      {required PostId postId, required String inCollection}) {
    return FirebaseFirestore.instance.runTransaction(
        maxAttempts: 3,
        timeout: const Duration(seconds: 20), (transaction) async {
      final query = await FirebaseFirestore.instance
          .collection(inCollection)
          .where(
            FirebaseFieldName.postId,
            isEqualTo: postId,
          )
          .get();
      for (final doc in query.docs) {
        transaction.delete(doc.reference);
      }
    });
  }
}
