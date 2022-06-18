// ignore_for_file: use_string_buffers

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:key_peer/utils/types.dart';

@immutable
class TextGenerator {
  const TextGenerator();

  int get _capitalsPercentage => 20;
  int get _maxWordLenght => 5;
  int get _numbersPercentage => 15;
  int get _punctuationPercentage => 30;

  String generate(TextGeneratorSettings settings) {
    if(settings.characters.isEmpty) {
      return 'key peer';
    }

    final random = Random();
    var text = '';

    while(text.length < settings.textMaxLength) {
      final word = _generateWord(
        settings.useNumbers && random.nextInt(100) < _numbersPercentage
          ? ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
          : settings.characters,
        !settings.useRepeatLetters,
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
    return text.trim().substring(0, settings.textMaxLength - 1).trim();
  }

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

@immutable
class TextGeneratorSettings {
  const TextGeneratorSettings({
    this.characters = const [],
    this.useRepeatLetters = false,
    this.useCapitalLetters = false,
    this.useNumbers = false,
    this.usePunctuation = false,
    this.textMaxLength = 25,
  });

  final List<String> characters;
  final int textMaxLength;
  final bool useCapitalLetters;
  final bool useNumbers;
  final bool usePunctuation;
  final bool useRepeatLetters;

  TextGeneratorSettings copyWith({
    Copyable<List<String>>? characters,
    Copyable<bool>? useRepeatLetters,
    Copyable<bool>? useCapitalLetters,
    Copyable<bool>? useNumbers,
    Copyable<bool>? usePunctuation,
    Copyable<int>? textMaxLength,
  }) => TextGeneratorSettings(
    characters: characters?.call() ?? this.characters,
    useRepeatLetters: useRepeatLetters?.call() ?? this.useRepeatLetters,
    useCapitalLetters: useCapitalLetters?.call() ?? this.useCapitalLetters,
    useNumbers: useNumbers?.call() ?? this.useNumbers,
    usePunctuation: usePunctuation?.call() ?? this.usePunctuation,
    textMaxLength: textMaxLength?.call() ?? this.textMaxLength,
  );
}
