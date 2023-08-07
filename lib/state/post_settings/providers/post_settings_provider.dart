import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/post_settings/models/post_setting.dart';
import 'package:instant_gram/state/post_settings/notifiers/post_settings_notifiers.dart';

import '../../image_upload/typedefs/is_loading.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSetting, IsLoading>>(
  (ref) => PostSettingNotifier(),
);
