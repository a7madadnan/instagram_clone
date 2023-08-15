import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/posts/typedefs/search_trem.dart';
import 'package:instant_gram/state/providers/posts_by_search_term_provider.dart';
import 'package:instant_gram/views/components/animations/data_not_found_animation_view.dart';
import 'package:instant_gram/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instant_gram/views/components/animations/error_animation_view.dart';
import 'package:instant_gram/views/components/animations/loading_animation_view.dart';
import 'package:instant_gram/views/components/post/posts_grid_view.dart';

import '../constants/strings.dart';

class SearchGridView extends ConsumerWidget {
  final SearchTerm searchTerm;
  const SearchGridView({
    required this.searchTerm,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTerm.isEmpty) {
      return const EmptyContentsWithTextAnimationView(
        text: Strings.enterYourSearchTerm,
      );
    }
    final posts = ref.watch(
      postBySearchTermProvider(
        searchTerm,
      ),
    );
    return posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const DataNotFoundAnimationView();
          }
          return PostsGridView(
            posts: posts,
          );
        },
        error: (_, __) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView());
  }
}
