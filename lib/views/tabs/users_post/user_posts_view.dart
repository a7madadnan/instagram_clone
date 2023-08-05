import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/state/posts/providers/user_posts_provider.dart';
import 'package:instant_gram/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';
import 'package:instant_gram/views/components/animations/loading_animation_view.dart';
import 'package:instant_gram/views/components/post/posts_grid_view.dart';
import 'package:instant_gram/views/constants/strings.dart';

class UserPostView extends ConsumerWidget {
  const UserPostView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //used to be final posts = ref.watch(userPostsProvider);
    AsyncValue<Iterable<Post>> posts = ref.watch(userPostsProvider);
    return RefreshIndicator(
      onRefresh: () {
        // using the value of refresh may cause a future problem
        posts = ref.refresh(userPostsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: posts.when(data: (posts) {
        if (posts.isEmpty) {
          return const EmptyContentsWithTextAnimationView(
              text: Strings.youHaveNoPosts);
        } else {
          return PostsGridView(posts: posts);
        }
      }, error: (error, stackTrace) {
        return const ErrorAnimationView();
      }, loading: () {
        return const LoadingAnimationView();
      }),
    );
  }
}
