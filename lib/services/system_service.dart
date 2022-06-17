// ignore_for_file: use_string_buffers

import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:key_peer/models/settings.dart';
import 'package:key_peer/typed_text.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_config.dart';


class SystemService {
  static final ConfettiController confettiController = ConfettiController(duration: const Duration(milliseconds: 1500));
  static final ValueNotifier<KeyboardConfig> keyboardConfig = ValueNotifier(KeyboardConfig.forLang());
  static final Stopwatch lessonClock = Stopwatch();
  // Settings
  static final ValueNotifier<Settings> settings = ValueNotifier(Settings());

  static final ValueNotifier<List<TypedKeyStatus>> statuses = ValueNotifier([]);
  static final ValueNotifier<String> targetText = ValueNotifier('monkey');

  static bool get isLessonCompleted {
    return statuses.value.every((status) =>
      status == TypedKeyStatus.correct ||
      status == TypedKeyStatus.corrected,
    );
  }

  /// When the user completes a lesson, we call this method which will register the completion.
  static void completeLesson() {
    lessonClock.stop();
  }

  static void generateTargetText() {
    targetText.value = _textGenerator.generateText(settings.value);
    statuses.value = targetText.value.characters.map((char) => TypedKeyStatus.none).toList();
  }

  static void startLesson() {
    lessonClock.start();
  }

  static void updateStatus(int index, TypedKeyStatus status) {
    if(index < statuses.value.length) {
      statuses.value[index] = status;
    }

    if(isLessonCompleted) {
      SystemService.confettiController.play();
    }
  }

  static final TextGenerator _textGenerator = TextGenerator();
}

class TextGenerator {
  String generateText(Settings settings) {
    final random = Random();
    var text = '';

    while(text.length < settings.textLength) {
      final word = _generateWord(
        settings.useNumbers && random.nextInt(100) < _numbersPercentage
          ? ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
          : settings.currentLesson?.characters ?? 'monkey'.split(''),
        !settings.repeatLetter,
      );

      // Discard 1 char words if it's not a vowel nor a number
      if(word.length == 1 && !word.contains(RegExp(r'([0-9]|[aeiou])'))) {
        continue;
      }

      text += '$word ';
    }

    // Capitalize words randomly
    if(settings.useCapitalLetters) {
      text = '${text.trim().split(' ').map((word) =>
        random.nextInt(100) < _capitalsPercentage
          ? word[0].toUpperCase() + word.substring(1)
          : word,
      ).join(' ')} ';

      text = text[0].toUpperCase() + text.substring(1);
    }

    // Add punctuation simbols
    if(settings.usePunctuation) {
      final words = text.trim().split(' ').map((word) =>
        random.nextInt(100) < _punctuationPercentage
          ? '$word${(['.', ',', ';', ':'].toList()..shuffle()).first}'
          : word,
      ).toList();

      // Capitalize next word after '.'
      text = words.first;
      for (var i = 1; i < words.length; i++) {
        final prevWord = words[i - 1];
        final word = words[i];
        text += prevWord[prevWord.length - 1] == '.'
          ? word[0].toUpperCase() + word.substring(1)
          : word;
        text += ' ';
      }
    }

    // Make sure we don't exceed the max length defined by the user
    return text.trim().substring(0, settings.textLength).trim();
  }

  final int _capitalsPercentage = 20;
  final int _maxWordLenght = 5;
  final int _numbersPercentage = 15;
  final int _punctuationPercentage = 30;

  String _generateWord(List<String> characters, bool ignore) {
    final random = Random();

    final wordLength = random.nextInt(_maxWordLenght) + 1;

    var word = '';
    while(word.length < wordLength) {
      final ignoreChar = ignore && word.isNotEmpty
        ? word[word.length - 1]
        : '';

      final filteredCharacters = characters.where((char) => char != ignoreChar).toList();
      word += filteredCharacters[random.nextInt(filteredCharacters.length)];
    }

    return word;
  }
}
