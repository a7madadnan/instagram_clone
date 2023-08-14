import 'package:flutter/material.dart';
import 'package:instant_gram/state/image_upload/models/file_type.dart';
import 'package:instant_gram/views/components/post/post_image_view.dart';
import 'package:instant_gram/views/components/post/post_video_view.dart';

import '../../../state/posts/models/post.dart';

class PostImageOrVideoView extends StatelessWidget {
  final Post post;
  const PostImageOrVideoView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    switch (post.fileType) {
      case FileType.image:
        return PostImageView(
          post: post,
        );
      case FileType.video:
        return PostVideoView(
          post: post,
        );
      default:
        return const SizedBox();
    }
  }
}
