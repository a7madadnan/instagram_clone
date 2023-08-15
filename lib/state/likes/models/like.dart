import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import '../../posts/typedefs/post_id.dart';
import '../../posts/typedefs/user_id.dart';

@immutable
class Like extends MapView<String, String> {
  Like({
    required PostId postId,
    required UserId userId,
    required DateTime date,
  }) : super({
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.date: date.toIso8601String(),
        });
}
