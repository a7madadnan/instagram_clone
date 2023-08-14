import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/state/user_info/providers/user_info_model_provider.dart';
import 'package:instant_gram/views/components/animations/small_error_animation_view.dart';
import 'package:instant_gram/views/components/rich_two_parts_text.dart';

class PostDisplayNameAndMessageView extends ConsumerWidget {
  final Post post;
  const PostDisplayNameAndMessageView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, ref) {
    final userInfoModel = ref.watch(
      userInfoModelProvider(
        post.userId,
      ),
    );
    return userInfoModel.when(
        data: (userInfoModel) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichTwoPortsText(
              leftPart: userInfoModel.displayName,
              rightPart: post.message,
            ),
          );
        },
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, _) => const SmallErrorAnimationView());
  }
}
