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

  static void generateTargetText() {
    targetText.value = _textGenerator.generateText(settings.value);
    statuses.value = targetText.value.characters.map((char) => TypedKeyStatus.none).toList();
  }
}

class TextGenerator {
  final int _maxWordLenght = 5;

  String _generateWord(List<String> characters, bool ignore) {
    Random random = Random();

    int wordLength = random.nextInt(_maxWordLenght) + 1;

    String word = '';
    while(word.length < wordLength) {
      String ignoreChar = ignore && word.isNotEmpty
        ? word[word.length - 1]
        : '';

      List<String> filteredCharacters = characters.where((char) => char != ignoreChar).toList();
      word += filteredCharacters[random.nextInt(filteredCharacters.length)];
    }

    return word;
  }

  String generateText(Settings settings) {
    String text = '';

    // print('>>> ${!settings.repeatLetter}');

    while(text.length < settings.textLength) {
      text += _generateWord(
        settings.currentLesson?.characters ?? 'monkey'.split(''),
        !settings.repeatLetter
      ) + ' ';
    }


    return text.substring(0, settings.textLength).trim();
  }
}