import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/providers/user_id_provider.dart';

import '../models/post.dart';

final canDeletePostProvider = StreamProvider.family.autoDispose<bool, Post>((
  ref,
  Post post,
) async* {
  final userId = ref.watch(userIdProvider);
  yield userId == post.userId;
  
});
