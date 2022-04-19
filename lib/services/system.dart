import 'package:flutter/material.dart';
import 'package:key_peer/typed_text.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_config.dart';
import 'package:confetti/confetti.dart';


class SystemService {
  static KeyEventController keyEventController = KeyEventController();
  static ConfettiController confettiController = ConfettiController(duration: const Duration(milliseconds: 1500));

  static ValueNotifier<KeyboardConfig> keyboardConfig = ValueNotifier(KeyboardConfig.forLang(lang: 'en'));
  static ValueNotifier<String> targetText = ValueNotifier('monkey');
  static ValueNotifier<List<TypedKeyStatus>> statuses = ValueNotifier([]);

  static Stopwatch lessonClock = Stopwatch();

  static bool get isLessonCompleted {
    return statuses.value.every((status) =>
      status == TypedKeyStatus.correct ||
      status == TypedKeyStatus.corrected
    );
  }

  static void startLesson() {
    lessonClock.start();
  }

  /// When the user completes a lesson, we call this method which will register the completion.
  static void completeLesson() {
    lessonClock.stop();
  }
}