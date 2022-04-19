import 'package:flutter/material.dart';
import 'package:key_peer/typed_text.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_config.dart';

class SystemService {
  static KeyEventController keyEventController = KeyEventController();
  static KeyboardConfig keyboardConfig = KeyboardConfig.forLang(lang: 'en');
  static ValueNotifier<String> targetText = ValueNotifier('monkey');
  static ValueNotifier<List<TypedKeyStatus>> statuses = ValueNotifier([]);

  static bool get isLessonCompleted {
    return statuses.value.every((status) =>
      status == TypedKeyStatus.CORRECT ||
      status == TypedKeyStatus.CORRECTED
    );
  }

  /// When the user completes a lesson, we call this method which will register the completion.
  static void completeLesson() {

  }
}