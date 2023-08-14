import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/likes/providers/post_likes_count_provider.dart';
import 'package:instant_gram/views/components/animations/small_error_animation_view.dart';
import 'package:instant_gram/views/components/constants/strings.dart';

import '../../state/posts/typedefs/post_id.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;
  const LikesCountView({
    super.key,
    required this.postId,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikesCountProvider(postId));
    return likesCount.when(
        data: (int likesCount) {
          final String personOrPeople =
              likesCount == 1 ? Strings.person : Strings.people;
          final String likesText =
              '$likesCount $personOrPeople ${Strings.likedThis} ';
          return Text(likesText);
        },
        error: (_, __) => const SmallErrorAnimationView(),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
