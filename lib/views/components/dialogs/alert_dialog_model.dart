import 'package:flutter/material.dart';

@immutable
class AletrDialogModel<T> {
  final String title;
  final String message;
  final Map<String, T> buttons;

  const AletrDialogModel({
    required this.title,
    required this.message,
    required this.buttons,
  });
}

extension Present<T> on AletrDialogModel<T> {
  Future<T?> present(BuildContext context) {
    return showDialog<T>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: buttons.entries.map((entry) {
              return TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      entry.value,
                    );
                  },
                  child: Text(
                    entry.key,
                  ));
            }).toList(),
          );
        });
  }
}
