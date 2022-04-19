import 'package:flutter/material.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_config.dart';

class SystemService {
  static KeyEventController keyEventController = KeyEventController();
  static KeyboardConfig keyboardConfig = KeyboardConfig.forLang(lang: 'en');
  static ValueNotifier<String> targetText = ValueNotifier('monkey likes bananas');
}