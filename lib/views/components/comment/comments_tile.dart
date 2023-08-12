import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/user_id_provider.dart';
import 'package:instant_gram/state/comments/models/comment.dart';
import 'package:instant_gram/state/comments/providers/delete_comment_provider.dart';
import 'package:instant_gram/state/user_info/providers/user_info_model_provider.dart';
import 'package:instant_gram/views/components/animations/small_error_animation_view.dart';
import 'package:instant_gram/views/components/dialogs/alert_dialog_model.dart';
import 'package:instant_gram/views/components/dialogs/delete_dialog.dart';
import 'package:instant_gram/views/constants/strings.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  const CommentTile({
    required this.comment,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(
        comment.userId,
      ),
    );
    return userInfo.when(data: (userInfo) {
      final currentUserId = ref.read(userIdProvider);
      return ListTile(
        title: Text(
          userInfo.displayName,
        ),
        subtitle: Text(comment.comment),
        trailing: currentUserId == comment.userId
            ? IconButton(
                onPressed: () async {
                  final shouldDeleteComment =
                      await displayDeleteDialog(context);
                  if (shouldDeleteComment) {
                    await ref
                        .read(deleteCommentProvider.notifier)
                        .deleteComment(commentId: comment.id);
                  }
                },
                icon: const Icon(
                  Icons.delete,
                ),
              )
            : null,
      );
    }, error: (error, stackTrace) {
      return const SmallErrorAnimationView();
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Future<bool> displayDeleteDialog(BuildContext context) =>
      const DeleteDialog(titleOfObjectToDelete: Strings.comments)
          .present(context)
          .then((value) => value ?? false);
}
