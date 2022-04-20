import 'dart:math';

import 'package:flutter/material.dart';
import 'package:key_peer/services/settings.dart';
import 'package:key_peer/typed_text.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_config.dart';
import 'package:confetti/confetti.dart';


class SystemService {
  static final KeyEventController keyEventController = KeyEventController();
  static final ConfettiController confettiController = ConfettiController(duration: const Duration(milliseconds: 1500));

  static final ValueNotifier<KeyboardConfig> keyboardConfig = ValueNotifier(KeyboardConfig.forLang(lang: 'en'));
  static final ValueNotifier<String> targetText = ValueNotifier('monkey');
  static final ValueNotifier<List<TypedKeyStatus>> statuses = ValueNotifier([]);

  // Settings
  static final ValueNotifier<Settings> settings = ValueNotifier(Settings());

  static final Stopwatch lessonClock = Stopwatch();

  static final TextGenerator _textGenerator = TextGenerator();

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

  static void updateStatus(int index, TypedKeyStatus status) {
    if(index < statuses.value.length) {
      statuses.value[index] = status;
    }

    if(isLessonCompleted) {
      SystemService.confettiController.play();
    }
  }

  static void generateTargetText(List<String> characters) {
    targetText.value = _textGenerator.generateText(characters.join().characters);
    statuses.value = targetText.value.characters.map((char) => TypedKeyStatus.none).toList();
  }
}

class TextGenerator {
  final int _maxTextLenght = 70;

  String _generateWord(Characters characters, int maxLenght) {
    Random random = Random();

    return List.generate(
      random.nextInt(maxLenght) + 1,
      (_) => characters.elementAt(random.nextInt(characters.length))
    ).join();
  }

  String generateText(Characters characters) {
    String text = '';
    while(text.length < _maxTextLenght) {
      text += _generateWord(characters, 5) + ' ';
    }

    return text.substring(0, _maxTextLenght).trim();
  }
}