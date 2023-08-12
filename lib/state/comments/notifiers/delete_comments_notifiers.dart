import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/comments/typedefs/comment_id.dart';
import 'package:instant_gram/state/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/image_upload/typedefs/is_loading.dart';

class DeleteCommentsStateNotifier extends StateNotifier<IsLoading> {
  DeleteCommentsStateNotifier() : super(false);
  set isLoading(bool value) => state = value;
  Future<bool> deleteComment({
    required CommentId commentId,
  }) async {
    try {
      isLoading = true;
      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectiondName.comments)
          .where(FieldPath.documentId, isEqualTo: commentId)
          .limit(1)
          .get();
      await query.then((query) async {
        for (final doc in query.docs) {
          await doc.reference.delete();
        }
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
