import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/views/components/constants/strings.dart';
import 'package:instant_gram/views/components/dialogs/alert_dialog_model.dart';

@immutable
class LogoutDialog extends AletrDialogModel<bool> {
  const LogoutDialog()
      : super(
            title: Strings.logout,
            message: Strings.areYouSureYouWantToLogOutOFTheApp,
            buttons: const {
              Strings.cancel: false,
              Strings.logout: true,
            });
}
