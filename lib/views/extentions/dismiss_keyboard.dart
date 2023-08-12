import 'package:flutter/material.dart';

extension DismissKeyBoard on Widget {
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
  
}
