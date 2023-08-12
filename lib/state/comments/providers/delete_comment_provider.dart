import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/comments/notifiers/delete_comments_notifiers.dart';

import '../../image_upload/typedefs/is_loading.dart';

final deleteCommentProvider =
    StateNotifierProvider<DeleteCommentsStateNotifier, IsLoading>(
  (ref) => DeleteCommentsStateNotifier(),
);
