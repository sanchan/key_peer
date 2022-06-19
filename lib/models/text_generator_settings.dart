
import 'package:flutter/material.dart';
import 'package:key_peer/utils/types.dart';

@immutable
class TextGeneratorSettings {
  const TextGeneratorSettings({
    this.characters = const ['e', 't', 'a', 'o'],
    this.lessonCharacters = const [
      ['e', 't', 'a', 'o'],
      ['n', 'i', 'h', 's', 'r'],
      ['d', 'l', 'u', 'm'],
      ['w', 'c', 'g', 'f'],
      ['y', 'p', 'b', 'v', 'k'],
      ["'", 'j', 'x', 'q', 'z'],
    ],
    this.useRepeatLetters = false,
    this.useCapitalLetters = false,
    this.useNumbers = false,
    this.usePunctuation = false,
    this.textMaxLength = 25,
  });

  final List<String> characters;
  final List<List<String>> lessonCharacters;
  final int textMaxLength;
  final bool useCapitalLetters;
  final bool useNumbers;
  final bool usePunctuation;
  final bool useRepeatLetters;

  TextGeneratorSettings copyWith({
    Copyable<List<String>>? characters,
    Copyable<List<List<String>>>? lessonCharacters,
    Copyable<bool>? useRepeatLetters,
    Copyable<bool>? useCapitalLetters,
    Copyable<bool>? useNumbers,
    Copyable<bool>? usePunctuation,
    Copyable<int>? textMaxLength,
  }) => TextGeneratorSettings(
    characters: characters?.call() ?? this.characters,
    lessonCharacters: lessonCharacters?.call() ?? this.lessonCharacters,
    useRepeatLetters: useRepeatLetters?.call() ?? this.useRepeatLetters,
    useCapitalLetters: useCapitalLetters?.call() ?? this.useCapitalLetters,
    useNumbers: useNumbers?.call() ?? this.useNumbers,
    usePunctuation: usePunctuation?.call() ?? this.usePunctuation,
    textMaxLength: textMaxLength?.call() ?? this.textMaxLength,
  );
}
